require 'spec_helper'

describe UnicornService::CapistranoIntegration do
  include UnicornService::Utility
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    UnicornService::CapistranoIntegration.load_into(@configuration)
    @configuration.set :application, 'myapp'
    @configuration.set :user,        'myuser'
    @configuration.set :deploy_to,   '/path/to/deploy'
    # @configuration.set :use_sudo,    true
  end

  it "defines unicorn_service:create_script" do
    @configuration.find_task('unicorn_service:create_script').should_not == nil
  end

  it "defines unicorn_service:update_rc" do
    @configuration.find_task('unicorn_service:update_rc').should_not == nil
  end

  it "defines unicorn_service:start" do
    @configuration.find_task('unicorn_service:start').should_not == nil
  end

  describe 'task unicorn_service:create_script' do
    before do
      @configuration.find_and_execute_task 'unicorn_service:create_script'
    end

    it 'set file as executable' do
      @configuration.should have_run("sudo -p 'sudo password: ' chmod +x /etc/init.d/unicorn.myapp")
    end
  end

  describe 'task unicorn_service:update_rc' do
    before do
      @configuration.find_and_execute_task 'unicorn_service:update_rc'
    end

    it 'runs update rc commands' do
      @configuration.should have_run("sudo -p 'sudo password: ' update-rc.d unicorn.myapp defaults")
    end
  end
end