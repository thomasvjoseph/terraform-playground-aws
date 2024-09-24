variable "acm_certificates" {
    description = "Map of ACM certificates"
    type = map(object({
        domain_name = string
    }))
}