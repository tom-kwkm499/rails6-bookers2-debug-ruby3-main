class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    if @book_comment.save
      redirect_to book_path(@book)
    else
      @user = @book.user
      @book_new = Book.new  # 必要ならば
      render 'books/show'  # 保存失敗時に元のページを表示
      flash[:alert] = 'コメントの投稿に失敗しました。'  # 必要ならば
    end
  end

  def destroy
    BookComment.find(params[:id]).destroy
    redirect_to book_path(params[:book_id])
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
