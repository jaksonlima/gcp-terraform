resource "local_file" "test" {
  content = var.content
  filename = "test.txt"
}

data "local_file" "content-text-file" {
  filename = "test.txt"
}

variable "content" {
  description = "The content of the file"
  type = string
  default = "Hello, World! Original"
}

output "content-data-base64" {
  value = data.local_file.content-text-file.content_base64
}

output "content-data" {
  value = data.local_file.content-text-file.content
}

output "content" {
  value = local_file.test.content
}

output "id" {
  value = local_file.test.id
}

output "chiken-egg" {
  value = sort(["egg", "chicken"])
}