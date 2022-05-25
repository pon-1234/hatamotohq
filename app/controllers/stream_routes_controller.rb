# frozen_string_literal: true

class StreamRoutesController < ApplicationController
  MAX_RETRY_TIME = 3
  RETRY_DELAY = 0.5

  def show
    @stream_route = StreamRoute.find_by code: params[:code]
    if params[:friendship_status_changed] && params[:line_user_id]
      update_source_for_line_friend
      if @line_friend.run_add_friend_actions && !@stream_route.actions_include_scenarios?
        # Need run add friend scenarios before run stream route actions
        AcquireFriendJob.perform_later(@line_friend.id)
      end
      # if stream route actions include any scenario then only run stream route actions anyway
      StreamRouteActionHandlerJob.perform_later(@line_friend, @stream_route.actions.first['data']) if @stream_route.actions.present?
    elsif params[:line_user_id] && @stream_route.always_run_actions
      # in case chose アクションの実行 -> いつでも then always run actions everytime user access the link
      @line_friend = LineFriend.find_by!(line_user_id: params[:line_user_id])
      StreamRouteActionHandlerJob.perform_later(@line_friend, @stream_route.actions.first['data']) if @stream_route.actions.present?      
    end
  end

  private
    def update_source_for_line_friend(retry_count = 0)
      retry_count += 1
      @line_friend = LineFriend.find_by!(line_user_id: params[:line_user_id])
      @line_friend.update!(stream_route_id: @stream_route.id)
    rescue => exception
      unless retry_count >= MAX_RETRY_TIME
        sleep RETRY_DELAY
        # use retry to avoid case line friend not exist because follow hook has not done yet
        retry
      else
        raise exception.message
      end
    end
end
