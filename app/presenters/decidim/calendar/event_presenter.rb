# frozen_string_literal: true

module Decidim
  module Calendar
    class EventPresenter < SimpleDelegator
      def color
        case __getobj__.class.name
        when "Decidim::ParticipatoryProcessStep"
          "#238ff7"
        when "Decidim::Meetings::Meeting"
          "#fabc6c"
        when "Decidim::Calendar::ExternalEvent"
          "#5fbd4c"
        end
      end

      def link
        return url if respond_to?(:url)

        @link ||= case __getobj__.class.name
                  when "Decidim::ParticipatoryProcessStep"
                    Decidim::ResourceLocatorPresenter.new(participatory_process).url
                  else
                    Decidim::ResourceLocatorPresenter.new(__getobj__).url
                  end
      end

      def start
        # byebug
        @start ||= if respond_to?(:start_date)
                     start_date
                   elsif respond_to?(:start_at)
                     start_at
                   else
                     start_time
                   end
      end

      def end
        @end ||= if respond_to?(:end_date)
                   end_date
                 elsif respond_to?(:end_at)
                   end_at
                 else
                   end_time
                 end
      end

      def full_title
        @full_title ||= case __getobj__.class.name
                        when "Decidim::ParticipatoryProcessStep"
                          participatory_process.title.merge(title) do |_k, v, o|
                            "#{v} - #{o}"
                          end
                        else
                          title
                        end
      end
    end
  end
end