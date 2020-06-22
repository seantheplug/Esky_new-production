class ConversationsController < ApplicationController
    before_action :authenticate_user!

    def index
      skip_policy_scope
      @conversations = policy_scope(Conversation).involving(current_user)
    end
  
    def create
      skip_policy_scope
      if Conversation.between(params[:sender_id], params[:recipient_id]).present?
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        @conversation = Conversation.create(conversation_params)
      end
      # if Conversation.where("conversations.sender_id = ? and conversations.recipient_id = ?", params[:sender_id], params[:recipient_id]).present?
      #   @conversation = Conversation..where("conversations.sender_id = ? and conversations.recipient_id = ?", params[:sender_id], params[:recipient_id]).first
      # else
      #   @conversation = Conversation.create!(conversation_params)
      # end
      authorize @conversation
      redirect_to conversation_messages_path(@conversation)
    end
  
    private
  
      def conversation_params
        params.permit(:sender_id, :recipient_id)
      end
  end