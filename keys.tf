resource "local_file" "private_key_ssh" {
    content  = tls_private_key.ec2key.private_key_openssh
    filename = "./key/private_key_ssh"
}
resource "local_file" "private_key" {
    content  = tls_private_key.ec2key.private_key_pem
    filename = "./key/private_key.pem"
}
resource "local_file" "pub_key" {
    content  = tls_private_key.ec2key.public_key_openssh
    filename = "./key/pub_key.pem"
}