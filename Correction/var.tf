variable "username" {
  description = "Function username"
  type        = string
  default     = "user1"
}
 

variable "password" {
  description = "Function password"
  type        = string
  default     = "**********"
}
 
variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
   
  }
}
 
