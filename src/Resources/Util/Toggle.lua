local Toggle = {}

function Toggle:Set(button,on,off,state)
	if button:IsA("TextButton") then
		button.MouseButton1Click:Connect(function ()
			if state then
				state = false
				if off then
					off()
				end
			else
				state = true
				if on then
					on()
				end
			end
		end)

	end
end



return Toggle
