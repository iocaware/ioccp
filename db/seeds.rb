# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(first_name: 'IOCAware', last_name: 'Admin', email: 'iocadmin@yourorg.com', isadmin: true, read_only: false, username: 'admin', password: 'admin', password_confirmation: 'admin')
# Default Agent Settings Seed
AgentSetting.create(name: "check_time", value: "1")
AgentSetting.create(name: "verify_ssl", value: 'false')
AgentSetting.create(name: "check_settings", value: '10')
AgentSetting.create(name: "agent_log", value: 'true')