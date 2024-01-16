local Toggle = {}

function Toggle:Set(button,options,set)
	if button:IsA("TextButton") then
		local current = 1
		
		button.MouseButton1Click:Connect(function ()
			
			if (current+1)<#options then
				
				set(options[current+1])
				current = current+1
			
			else
				set(options[1])
				current = 1
			end
		end)

	end
end



return Toggle
