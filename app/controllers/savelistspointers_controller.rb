class SavelistspointersController < ApplicationController
    def create 
        puts "ok"
        output = params["service_id"]
        puts output
        puts "current user savelist id #{current_user.savelist.id}"
        @savelistspointer = Savelistspointer.create!(savelist_id: current_user.savelist.id, service_id: params["service_id"].to_i)
        skip_authorization
        head :ok
    end

    def destroy
        puts "delete service from savelist"
        puts params
        @savelistspointer_to_destroy =  Savelistspointer.find(params["id"])
        @savelistspointer_to_destroy.destroy!
        skip_authorization
        head :ok
    end

end