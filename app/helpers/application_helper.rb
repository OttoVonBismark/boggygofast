module ApplicationHelper

    # Returns the full title on a per-page basis.
    def full_title(page_title = '')
        base_title = "BoggyGoFast Speedrun Archive"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end

    # Sets button text where necessary.
    def button_text(button_name = '')
        button_base_name = "Proceed"
        if button_name.empty?
            button_base_name
        end
    end
end
