### AWS SSH With Ruby

Simple ruby script using the aws-sdk to list out your instances in a region and ssh into them with tab completion.

### Setup

Edit the following 4 lines of the aws_ssh.rb file

aws_key = "AWS_KEY"
aws_sec = "AWS_SECRET"
region = 'us-east-1' 
ssh_user = 'ec2-user'

### Requirements

rubygems
readline
aws-sdk

### Usage

```bash
macbook $ ./aws_ssh.rb 
One second....Grabbing EC2 Instances
commands (list info ssh help quit):
> list
Dev Server    Dev Server 2
> ssh Dev Server 2
```

### More

This project is no longer being updated as I have since moved on to working on an actual electron app to provide this functionality:

[Opshell](https://github.com/ricktbaker/opshell)

