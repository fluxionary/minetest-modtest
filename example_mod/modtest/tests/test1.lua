modtest.with_environment("run some tests in the modtest environment", function()
	it("node is defined", function()
		assert.is_not_nil(minetest.registered_nodes["example_mod:node"])
	end)
	it("tool is defined", function()
		assert.is_not_nil(minetest.registered_tools["example_mod:tool"])
	end)
end)
