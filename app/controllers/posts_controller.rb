class PostsController < ApplicationController

  before_action :authorize_request 
     # Handle ActiveRecord Not Found exception
 rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

     # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
     rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  # POST (If logged in)
  def create
    current_user = @current_user
    if current_user.role == "admin"

        post = Post.new(post_params)
        post.user_id = current_user.id 
        post.image.attach(post_params[:image]) unless post_params[:image].nil?
        if post.save
          user_id = post.user_id
          title = post.title
          body = post.body
          PostMailer.new_post_notification(user_id: user_id, title: title, body: body, image_url: url_for(post.image)).deliver_later

            render json: {message: "Post sent"}, status: :ok
        else
            render json: post.errors.full_messages, status: :unprocessable_entity
        end
    else
        render json: { error: 'Unauthorized'}, status: :unauthorized
    end
end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

    def render_not_found_response
      render json: { error: 'Record not found' }, status: :not_found
    end
  
    def render_unprocessable_entity_response(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

end
