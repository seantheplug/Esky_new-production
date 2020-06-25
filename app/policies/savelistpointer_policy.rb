class SavelistspointerPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  
   
    def create?
      # record.savelist.user == user
      true
    end
  
    def destroy?
      true
    end
  end