describe 'RSpec' do
	it 'asserts as expected' do
		false.should eq(false)
		"Ruby".should eq("Ruby")
		"RSpec".should_not eq("Arse Peck")
	end
end