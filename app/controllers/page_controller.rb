class PageController < BaseController

  def show
    @sidebar_left = true
    @page = Comatose::Page.where(:slug => params[:id]).first
    @children = @page.children if @page

    # TODO: Will have to change slug.
    @home = Comatose::Page.where(:slug => "about").first

    # If there are no children, then we make the navigation
    # column contain the children of the parent. If we are
    # at the root, we are just home.
    if @children.empty?
      p = @page.parent ? @page.parent : @home
      @children = p.children
    end

    render :layout => "homepage"
  end
end