#!/usr/bin/env ruby

# aws api info
aws_key = "AWS_KEY"
aws_sec = "AWS_SECRET"
region = 'us-east-1'
ssh_user = 'ec2-user'

# Here we go
require 'readline'
require 'rubygems'

puts "One second....Grabbing EC2 Instances"

begin
  require 'aws-sdk'
rescue LoadError
  puts "You need to have the ruby aws-sdk installed"
  puts "gem install aws-sdk"
end

Aws.config.update({
  region: region,
  credentials: Aws::Credentials.new(aws_key,aws_sec)
})

ec2 = Aws::EC2::Client.new(region: region) 

instanceHash = {}
tabComplete = []

ec2.describe_instances.each do |page|
  page.reservations.each do |reservation|
    reservation.instances.each do |instance|
      nameTag = ''
      tags = instance.tags
      tags.each do |num|
        if num[0] == 'Name' 
          nameTag = num[1]
        end
      end
      tabComplete.push(nameTag)
      instanceHash[nameTag] = {:ip => instance.private_ip_address,:id => instance.instance_id,:key => instance.key_name}
    end
  end
end

puts 'commands (list info ssh help quit):'

##
tabComplete = tabComplete.sort

comp = proc { |s| tabComplete.grep(/^#{Regexp.escape(s)}/) }

Readline.completion_append_character = " "
Readline.completion_proc = comp

command = '';
while command = Readline.readline('> ', true)
	if command.start_with?('list')
		i=0
		tabComplete.each do|serverName|
			print "#{serverName}".ljust(30)
			i += 1
			if i == 2
				i = 0
				print "\n"
			end
		end
		print "\n"
	end
	if command.start_with?('ssh','info')
		commands = command.split(' ');
		if !commands[1]
			puts 'Enter a server name'
		else
			serverName = commands[1].strip
			server = instanceHash[serverName]
			if server
				if commands[0] == 'ssh'
					if File.exist?(Dir.home + '/.ssh/systems.pem')
						ssh = 'ssh -o UserKnownHostsFile=/dev/null -o stricthostkeychecking=no -l ' + ssh_user + ' -i ~/.ssh/' + server[:key] + '.pem ' + server[:ip] 
						exec (ssh)
					else
						puts 'Cannot find ~/.ssh/' + server[:key] + '.pem'
					end
				else
					puts 'Server Info'
					puts server
				end
			else
				puts 'Server not found'
			end
		end
	end
	if command.start_with?('quit','exit') 
		exit
	end
	if command.start_with?('help')
		puts "list\tList All Servers"
		puts "ssh\tssh servername (tab completion works here)"
		puts "info\tinfo servername (tab completion works here)"
		puts "help\tthis message"
		puts "quit\tquit script (exit works as well)"
	end
end

if command == 'list'
	puts tabComplete
end
