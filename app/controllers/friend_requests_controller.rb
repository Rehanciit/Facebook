class FriendRequestsController < ApplicationController
  before_action :require_login, only: %i[ index create edit update destroy ]
  before_action :require_owner, only: %i[ destroy ]


  def index
    @users = User.where.not(id: current_user.id)
    @sent_friend_requestsids = current_user.sent_friend_requests.where(accepted:false).pluck(:receiver_id)
    @received_friend_requestsids = current_user.received_friend_requests.where(accepted:false).pluck(:sender_id)
    @friends = current_user.sent_friend_requests.where(accepted: true).map(&:receiver) +
                current_user.received_friend_requests.where(accepted: true).map(&:sender)

  end
  # POST Friend Request
  def create
    @friend_request= FriendRequest.new(accepted: false, sender_id: current_user.id, receiver_id: params[:receiver_id])    
    if @friend_request.save
      redirect_to friends_path, notice: 'Friend Request sent!'
    else
      redirect_to friends_path, alert: @friend_request.errors.full_messages.join(', ')
    end
    
  end

  # PATCH/PUT /friend request Accept
  def update
    @friend_request = FriendRequest.find_by(receiver_id:current_user.id ,sender_id:params[:sender_id]);
    @friend_request.accepted = params[:accept]
    if @friend_request.save
      redirect_to friends_path, notice: 'Friend Request accepted!'
    else
      redirect_to friends_path, alert: @friend_request.errors.full_messages.join(', ')
    end

  end

  # DELETE unfriend, Friend Request deleted
  def destroy
    if @friend_request.destroy
      redirect_to friends_path, notice: 'Friend Request deleted!'
    else
      redirect_to friends_path, alert: @friend_request.errors.full_messages.join(', ')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def require_login
      unless current_user
        redirect_to user_session_path, alert: 'Please log in.'
      end
    end

    def require_owner
      @friend_request = FriendRequest.find_by(receiver_id:params[:receiver_id],sender_id:current_user.id);
      unless @friend_request
        redirect_to user_session_path, alert: 'Please log in.'
      end
    end
end
