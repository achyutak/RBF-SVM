function Reg_param = fetchval(max)
Reg_param = [];
for i = 1:max
    val = input("Enter the "+ i + " of " + max +" Regularization Paramters one by one(Hit enter after each value). Enter  'e'  if complete\n" );
    if isnumeric(val) && ~isnan(val)
        Reg_param(end+1) = val;
        i = i + 1;
    else
        if val == 'e'
            if isempty(Reg_param)
                error("No Value Entered");
        break;
        else
            disp("Incorrect value entered");
        end
    end
end
end