#!/bin/bash
set -e

# ========== LOGGING SETUP ==========
LOG_FILE="/var/log/user-data-setup.log"
exec > >(tee -a $LOG_FILE)
exec 2>&1

echo "=========================================="
echo "Starting User Data Execution: $(date)"
echo "=========================================="

# ========== VARIABLES ==========
DEVICE_NAME="${device_name}"      # e.g., /dev/xvdf (will be /dev/nvme1n1 on Nitro instances)
MOUNT_POINT="${mount_point}"      # e.g., /mnt/data
LOG_GROUP_NAME="${log_group}"     # CloudWatch log group name

echo "Configuration:"
echo "  Device Name: $DEVICE_NAME"
echo "  Mount Point: $MOUNT_POINT"
echo "  Log Group: $LOG_GROUP_NAME"

# ========== WAIT FOR EBS VOLUME ==========
echo "Waiting for EBS volume to be attached..."
MAX_WAIT=60
COUNTER=0

# Function to find the actual device
find_device() {
    # Check for NVMe devices (Nitro instances)
    if [ -b "/dev/nvme1n1" ]; then
        echo "/dev/nvme1n1"
        return 0
    fi
    
    # Check for traditional device names
    if [ -b "$DEVICE_NAME" ]; then
        echo "$DEVICE_NAME"
        return 0
    fi
    
    # Check for alternative device name (sometimes xvdf appears as sdf)
    ALT_DEVICE=$(echo $DEVICE_NAME | sed 's/xvd/sd/')
    if [ -b "$ALT_DEVICE" ]; then
        echo "$ALT_DEVICE"
        return 0
    fi
    
    return 1
}

# Wait for device to appear
while [ $COUNTER -lt $MAX_WAIT ]; do
    ACTUAL_DEVICE=$(find_device)
    if [ $? -eq 0 ]; then
        echo "Device found: $ACTUAL_DEVICE"
        break
    fi
    echo "Waiting for device... ($COUNTER/$MAX_WAIT)"
    sleep 2
    COUNTER=$((COUNTER + 2))
done

if [ -z "$ACTUAL_DEVICE" ] || [ ! -b "$ACTUAL_DEVICE" ]; then
    echo "ERROR: EBS volume not found after $MAX_WAIT seconds!"
    echo "Available block devices:"
    lsblk
    exit 1
fi

# ========== SYSTEM UPDATE ==========
echo "Updating system packages..."
if [ -f /etc/lsb-release ]; then
    # Ubuntu/Debian
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y unzip wget curl
elif [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
    # CentOS / RHEL
    yum update -y
    yum install -y unzip wget curl
elif [ -f /etc/system-release ] && grep -q "Amazon Linux" /etc/system-release; then
    # Amazon Linux
    yum update -y
    yum install -y unzip wget curl
fi

# ========== MOUNT EBS VOLUME ==========
echo "=========================================="
echo "Mounting EBS Volume"
echo "=========================================="

# Check if device has a filesystem
HAS_FILESYSTEM=$(file -s $ACTUAL_DEVICE | grep -c "filesystem" || true)

if [ "$HAS_FILESYSTEM" -eq 0 ]; then
    echo "No filesystem detected on $ACTUAL_DEVICE. Creating ext4 filesystem..."
    mkfs -t ext4 $ACTUAL_DEVICE
    echo "Filesystem created successfully"
else
    echo "Filesystem already exists on $ACTUAL_DEVICE"
fi

# Create mount point if it doesn't exist
echo "Creating mount point: $MOUNT_POINT"
mkdir -p $MOUNT_POINT

# Check if already mounted
if mount | grep -q "$MOUNT_POINT"; then
    echo "Device already mounted at $MOUNT_POINT, unmounting first..."
    umount $MOUNT_POINT
fi

# Mount the device
echo "Mounting $ACTUAL_DEVICE to $MOUNT_POINT..."
mount $ACTUAL_DEVICE $MOUNT_POINT

# Get UUID for fstab
UUID=$(blkid -s UUID -o value $ACTUAL_DEVICE)
echo "Device UUID: $UUID"

# Add to fstab if not already present
if ! grep -q "$UUID" /etc/fstab; then
    echo "Adding entry to /etc/fstab..."
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
    echo "Entry added to /etc/fstab"
else
    echo "Entry already exists in /etc/fstab"
fi

# Set proper permissions
chown root:root $MOUNT_POINT
chmod 755 $MOUNT_POINT

# Verify mount
echo "Verifying mount..."
df -h $MOUNT_POINT
echo "Mount successful!"

# ========== INSTALL CLOUDWATCH AGENT ==========
echo "=========================================="
echo "Installing CloudWatch Agent"
echo "=========================================="

# Determine the correct installer URL based on OS
if [ -f /etc/lsb-release ]; then
    CW_AGENT_URL="https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb"
    echo "Downloading CloudWatch Agent for Ubuntu/Debian..."
    wget -q $CW_AGENT_URL -O /tmp/amazon-cloudwatch-agent.deb
    dpkg -i /tmp/amazon-cloudwatch-agent.deb
    rm -f /tmp/amazon-cloudwatch-agent.deb
else
    CW_AGENT_URL="https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm"
    echo "Downloading CloudWatch Agent for Amazon Linux/RHEL..."
    wget -q $CW_AGENT_URL -O /tmp/amazon-cloudwatch-agent.rpm
    rpm -U /tmp/amazon-cloudwatch-agent.rpm
    rm -f /tmp/amazon-cloudwatch-agent.rpm
fi

echo "CloudWatch Agent installed successfully"

# ========== CREATE CLOUDWATCH AGENT CONFIG ==========
echo "Creating CloudWatch Agent configuration..."

mkdir -p /opt/aws/amazon-cloudwatch-agent/bin

cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          {
            "name": "cpu_usage_idle",
            "rename": "cpu_usage_idle",
            "unit": "Percent"
          },
          {
            "name": "cpu_usage_active",
            "rename": "cpu_usage_active",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "totalcpu": true
      },
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "disk_used_percent",
            "unit": "Percent"
          },
          {
            "name": "free",
            "rename": "disk_free",
            "unit": "Gigabytes"
          }
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/",
          "MOUNT_POINT_PLACEHOLDER"
        ]
      },
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "mem_used_percent",
            "unit": "Percent"
          },
          {
            "name": "mem_available",
            "rename": "mem_available",
            "unit": "Megabytes"
          }
        ],
        "metrics_collection_interval": 60
      },
      "net": {
        "measurement": [
          {
            "name": "bytes_sent",
            "rename": "net_bytes_sent",
            "unit": "Bytes"
          },
          {
            "name": "bytes_recv",
            "rename": "net_bytes_recv",
            "unit": "Bytes"
          },
          {
            "name": "packets_sent",
            "rename": "net_packets_sent",
            "unit": "Count"
          },
          {
            "name": "packets_recv",
            "rename": "net_packets_recv",
            "unit": "Count"
          }
        ],
        "metrics_collection_interval": 60
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ],
        "metrics_collection_interval": 60
      }
    },
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}",
      "InstanceType": "$${aws:InstanceType}",
      "ImageId": "$${aws:ImageId}"
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/user-data-setup.log",
            "log_group_name": "LOG_GROUP_PLACEHOLDER",
            "log_stream_name": "{instance_id}/user-data",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "LOG_GROUP_PLACEHOLDER",
            "log_stream_name": "{instance_id}/messages",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "LOG_GROUP_PLACEHOLDER",
            "log_stream_name": "{instance_id}/syslog",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "LOG_GROUP_PLACEHOLDER",
            "log_stream_name": "{instance_id}/cloud-init",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

# Replace placeholders
sed -i "s|MOUNT_POINT_PLACEHOLDER|$MOUNT_POINT|g" /opt/aws/amazon-cloudwatch-agent/bin/config.json
sed -i "s|LOG_GROUP_PLACEHOLDER|$LOG_GROUP_NAME|g" /opt/aws/amazon-cloudwatch-agent/bin/config.json

echo "CloudWatch Agent configuration created"

# ========== START CLOUDWATCH AGENT ==========
echo "Starting CloudWatch Agent..."

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

# Verify CloudWatch Agent is running
sleep 5
if /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a query | grep -q "running"; then
    echo "✅ CloudWatch Agent is running"
else
    echo "❌ CloudWatch Agent failed to start"
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a query
fi

# ========== FINAL VERIFICATION ==========
echo "=========================================="
echo "Final System Status"
echo "=========================================="
echo ""
echo "Mounted filesystems:"
df -h
echo ""
echo "Block devices:"
lsblk
echo ""
echo "fstab entries:"
grep -v "^#" /etc/fstab | grep -v "^$"
echo ""
echo "=========================================="
echo "Setup completed successfully: $(date)"
echo "=========================================="