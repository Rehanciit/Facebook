module PostsHelper
    def render_comments(comments)
        comments.map do |comment|
          unless comment.parent_comment
            render_comment(comment) +
              render_child_comments(comment.replies)
          end
        end.join.html_safe
      end
    
      def render_comment(comment)
        content_tag(:div) do
          concat(content_tag(:strong, comment.user.username))
          concat(": ")
          concat(comment.content)
          concat(tag(:br))
          concat(link_to("Show this comment", comment))
          concat(tag(:br))
          concat(link_to("Reply to this comment", newreply_path(@post, comment)))
          concat(tag(:br))
        end
      end
    
      def render_child_comments(replies)
        replies.map do |reply|
          content_tag(:div, class: "ml-4") do
            render_comment(reply) +
              render_child_comments(reply.replies)
          end
        end.join.html_safe
      end
end
