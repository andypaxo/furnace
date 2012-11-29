require 'rspec'
require 'combined_status'

describe 'Combined status' do
	it 'should combine git and multiple CC inputs' do
		gh = double('Github')
		gh.should_receive(:set_access_token)
		  .with('c75hf')
		gh.should_receive(:grab_activity)
		  .with('Lister')
		  .and_return([{'type' => 'PushEvent'}])

		cruise = double('Cruise')
		cruise.should_receive(:grab_status)
		      .with('ccnet.org', 'Rimmer', '89cb3')
		      .and_return([
		      	{:name => 'Orion', :status => 'OK'},
		      	{:name => 'Mars', :status => 'Fail'}
		      ])
		cruise.should_receive(:grab_status)
		      .with('ccnet.org', 'Kryten', 'n49cs')
		      .and_return([
		      	{:name => 'Andromeda', :status => 'OK'}
		      ])

		sut = CombinedStatus.new(gh, cruise)

		sut.set_github('Lister', 'c75hf')
		sut.add_cruise('ccnet.org', 'Rimmer', '89cb3')
		sut.add_cruise('ccnet.org', 'Kryten', 'n49cs')

		result = sut.get_status
		gh_status = result[:github]
		gh_status[0]['type'].should eq('PushEvent')

		cc_status = result[:status]
		cc_status[0][:name].should eq('Orion')
		cc_status[1][:name].should eq('Mars')
		cc_status[2][:name].should eq('Andromeda')
		cc_status[0][:status].should eq('OK')
		cc_status[1][:status].should eq('Fail')
		cc_status[2][:status].should eq('OK')
	end
end