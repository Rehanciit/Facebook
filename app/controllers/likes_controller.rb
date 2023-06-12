class LikesController < ApplicationController
    before_action :set_post, only: %i[ like unlike ]
    before_action :require_login, only: %i[ like unlike]
    before_action :require_owner, only: %i[  unlike]

    def like
        like=@post.likes.create(user_id:current_user.id)
        if like.save
            redirect_to post_path(@post), notice: 'Liked the post!'
        else
            redirect_to post_path(@post), alert: 'Unable to like the post.'
        end
    end

    def unlike
        if@like.destroy
            redirect_to post_path(params[:id]), notice: 'Unliked the post!'
        else
            redirect_to post_path(params[:id]), alert: 'Unable to unlike the post.'
        end
    end

    private

    def set_post
        @post = Post.find(params[:id])
    end
    def require_login
        unless current_user
            redirect_to user_session_path, alert: 'Please log in.'
        end
    end
    def require_owner
      @like = @post.likes.find_by(user:current_user)
      unless @like
        redirect_to user_session_path, alert: 'Please log in as like owner.'
      end
    end
end
