##Save from Google search

Step 1: Create public and private keys using ssh-key-gen on local-host
jsmith@local-host$ [Note: You are on local-host here]

jsmith@local-host$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/jsmith/.ssh/id_rsa):[Enter key]
Enter passphrase (empty for no passphrase): [Press enter key]
Enter same passphrase again: [Pess enter key]
Your identification has been saved in /home/jsmith/.ssh/id_rsa.
Your public key has been saved in /home/jsmith/.ssh/id_rsa.pub.
The key fingerprint is:
33:b3:fe:af:95:95:18:11:31:d5:de:96:2f:f2:35:f9 jsmith@local-host


Step 2: Copy the public key to remote-host using ssh-copy-id.
ssh-copy-id appends the keys to the remote-host’s .ssh/authorized_key.
jsmith@local-host$ ssh-copy-id -i ~/.ssh/id_rsa.pub remote-host
