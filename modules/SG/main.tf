resource "aws_security_group" "security_group" {
  for_each    = var.sg_resources
  name        = each.value.sg_name
  description = each.value.sg_description
  vpc_id      = var.vpc_id

  # Dynamic Ingress Rule
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol

      # Conditionally use cidr_blocks or source_security_group_ids
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  # Dynamic Egress Rule
  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      protocol  = egress.value.protocol

      # Conditionally use cidr_blocks or source_security_group_ids
      cidr_blocks     = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_groups", [])
    }
  }

  tags = var.tags
}


#Note
/* 
  •	lookup Function: This function is used to check for the presence of a key in a map. If the key (e.g., cidr_blocks or security_groups) is present in the rule, it will be used. If not, it defaults to an empty list [].
	•	cidr_blocks = lookup(ingress.value, "cidr_blocks", []): This will use cidr_blocks if provided; otherwise, it will use an empty list.
	•	security_groups = lookup(ingress.value, "security_groups", []): Similarly, it will use security_groups if provided; otherwise, it will default to an empty list. 
*/