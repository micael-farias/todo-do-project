module BoardsHelper
    def priority_color_class(priority)
        case priority
        when 1 then 'bg-green-500 border-green-700'
        when 2 then 'bg-yellow-500 border-yellow-700'
        when 3 then 'bg-blue-500 border-blue-700'
        when 4 then 'bg-red-500 border-red-700'
        else 'bg-gray-500 border-gray-700'
        end
      end
end
