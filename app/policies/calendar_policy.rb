class CalendarPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def provider?
        record.user == user
    end
  end