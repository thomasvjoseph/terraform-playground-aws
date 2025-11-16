resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.dashboard_name_prefix}-${var.environment}-EC2"

  dashboard_body = jsonencode({
    widgets = flatten([
      var.enable_ec2_dashboard ? [
        for instance_id, instance_name in var.ec2_instances : flatten([
          # -------------------- CPU --------------------
          {
            "type" : "metric",
            "x" : 0,
            "y" : 0,
            "width" : 6,
            "height" : 6,
            "properties" : {
              "metrics" : [
                ["CWAgent", "cpu_usage_active", "InstanceId", instance_id, { "stat" : "Average", "label" : "Average" }],
                ["...", { "stat" : "Maximum", "label" : "Maximum" }],
                ["...", { "stat" : "Minimum", "label" : "Minimum" }],
                ["...", { "stat" : "Sum", "label" : "Total" }]
              ],
              "view" : "timeSeries",
              "stacked" : false,
              "region" : var.region,
              "title" : "CPU - ${instance_name}",
              "period" : 300
            }
          },

          # -------------------- Memory --------------------
          {
            "type" : "metric",
            "x" : 6,
            "y" : 0,
            "width" : 6,
            "height" : 6,
            "properties" : {
              "metrics" : [
                ["CWAgent", "mem_used_percent", "InstanceId", instance_id, { "stat" : "Average", "label" : "Used %" }],
                ["CWAgent", "mem_available", "InstanceId", instance_id, { "stat" : "Average", "label" : "Available %" }],
                ["CWAgent", "mem_total", "InstanceId", instance_id, { "stat" : "Average", "label" : "Total" }]
              ],
              "view" : "timeSeries",
              "stacked" : false,
              "region" : var.region,
              "title" : "Memory - ${instance_name}",
              "period" : 300
            }
          },

          # -------------------- Storage --------------------
          {
            "type" : "metric",
            "x" : 12,
            "y" : 0,
            "width" : 6,
            "height" : 6,
            "properties" : {
              "metrics" : [
                # Root volume
                ["CWAgent", "disk_used_percent", "InstanceId", instance_id, "path", "/", { "stat" : "Average", "label" : "Used /" }],
                ["CWAgent", "disk_free", "InstanceId", instance_id, "path", "/", { "stat" : "Average", "label" : "Free /" }],
                ["CWAgent", "disk_total", "InstanceId", instance_id, "path", "/", { "stat" : "Average", "label" : "Total /" }],
                # Optional additional mount points
                ["CWAgent", "disk_used_percent", "InstanceId", instance_id, "path", "/mnt/data", { "stat" : "Average", "label" : "Used /mnt/data" }],
                ["CWAgent", "disk_free", "InstanceId", instance_id, "path", "/mnt/data", { "stat" : "Average", "label" : "Free /mnt/data" }],
                ["CWAgent", "disk_total", "InstanceId", instance_id, "path", "/mnt/data", { "stat" : "Average", "label" : "Total /mnt/data" }]
              ],
              "view" : "timeSeries",
              "stacked" : false,
              "region" : var.region,
              "title" : "Disk - ${instance_name}",
              "period" : 300
            }
          },

          # -------------------- Network --------------------
          {
            "type" : "metric",
            "x" : 0,
            "y" : 6,
            "width" : 12,
            "height" : 6,
            "properties" : {
              "metrics" : [
                ["CWAgent", "net_bytes_sent", "InstanceId", instance_id, { "stat" : "Sum", "label" : "Bytes Sent" }],
                ["CWAgent", "net_bytes_recv", "InstanceId", instance_id, { "stat" : "Sum", "label" : "Bytes Received" }],
                ["CWAgent", "net_packets_sent", "InstanceId", instance_id, { "stat" : "Sum", "label" : "Packets Sent" }],
                ["CWAgent", "net_packets_recv", "InstanceId", instance_id, { "stat" : "Sum", "label" : "Packets Received" }]
              ],
              "view" : "timeSeries",
              "stacked" : false,
              "region" : var.region,
              "title" : "Network - ${instance_name}",
              "period" : 300
            }
          }
        ])
      ] : []
    ])
  })
}
