module AcctHelper
  
  def options_for_showing(action_sets, selected_action_set_name)

     selected = "All"
     disabled = "All"
     opts = [[ "All", ""]]
     for a in action_sets do
       as = "#{a.id}"
       opts += [[a.name, as]]
       if a.name == selected_action_set_name
         selected = a.name
         disabled = a.name
       end
    end
    select_options = options_for_select(opts,
                        :selected => selected,
                        :disabled => disabled)
  end

end