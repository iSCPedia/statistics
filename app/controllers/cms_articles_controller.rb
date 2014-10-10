class CmsArticlesController < ApplicationController
  
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :find_objects
  helper_method :sort_column, :sort_direction

  def index        
    @cms_articles = Cms::Article.where("tag IS NOT null AND tag <> '' AND is_published = true ").order(:position)
    if params["tag"].present?
      @cms_other_articles = Cms::Article.where(archieved: true)
      @selected_article = "other"
      @setting = Setting.first
    else
      cms = Cms::Article.where(home_page: true).first
      if cms
        redirect_to "/#{cms.slug}"  
      end      
    end
  end

  def allArticles
    @cms_articles = Cms::Article.find(:all, order: sort_column + " " + sort_direction)
  end

  def publish_or_archieve
    msg = ""    
    if params[:type] == "publish"
      @cms_article.update_attributes(is_published: true)
      msg = "Pusblish"    
    elsif params[:type] == "archieved"
      @cms_article.update_attributes(archieved: true,is_published: false)
      msg = "Archieved"
    elsif params[:type] == "re-publish"
      @cms_article.update_attributes(archieved: false,is_published: true)
      msg = "Re-publish Article"
    end  
    redirect_to all_articles_path, notice: " Updated to #{msg}"
  end

  def show
    #page_views = Data::Filz.ga_fetch_data[:page_views]
    # page_views = Data::Filz.ga_fetch_data[:page_country]    
    # render text: page_views.to_json
    @cms_articles = Cms::Article.where("tag IS NOT null AND tag <> '' AND is_published = true").order(:position)
    @selected_article = @cms_article.slug
    @setting = Setting.first
    @template = JSON.parse(@setting.page_builder_config)
    if !Data::Filz.where(slug: "#{@selected_article}-traffic").last.nil?
      @all_years = JSON.parse(Data::Filz.where(slug: "#{@selected_article}-traffic").last.content)
      @all_years.shift
      @all_years = @all_years.collect{|k| k[5]}.uniq.sort{|k| -k}
    end
    @provider = Provider.where(name: @cms_article.title).first
    gon.width = ""
    gon.height = ""
  end

  def new
    @cms_article = Cms::Article.new
    @all_articles_titles = Cms::Article.where(is_autogenerated: "false").select("title,slug")
    @viz_vizs = Viz::Viz.find(:all, order: "updated_at desc")
    gon.width = "300px"
    gon.height = "300px"
  end

  def edit
    gon.width = "300px"
    gon.height = "300px"
    @cms_article = Cms::Article.where(slug: "#{params[:file_id]}").first
    @csm_article_nested_content = JSON.parse(@cms_article.nested_pages) if @cms_article.nested_pages
    @all_articles_titles = Cms::Article.where(is_autogenerated: "false").select("title,slug")
  end
  
  def create
    @cms_article = Cms::Article.new(params[:cms_article])
    @cms_article.position = 0
    @cms_article.is_published = false
    @cms_article.nested_pages = JSON.parse(params[:nested_pages]).to_json if params[:cms_article]["has_nested_pages"].to_i == 1
    if params[:commit] == "Publish"
      @cms_article.is_published = params[:commit] == "Publish" ? true : false
    end
    @cms_article.description.to_s.html_safe
    if @cms_article.save
      redirect_to cms_article_path(file_id: @cms_article.slug), notice: t("c.s")
    else
      @viz_vizs = Viz::Viz.find(:all, order: "updated_at desc")
      gon.errors = @cms_article.errors
      gon.width = "300px"
      gon.height = "300px"      
      render action: "new"
    end
  end

  def update
    @cms_article.is_published = false
    if params[:commit] == "Publish"
      @cms_article.is_published = true
    end
    @cms_article.nested_pages = JSON.parse(params[:nested_pages]).to_json if params[:cms_article]["has_nested_pages"].to_i == 1
    @cms_article.description.to_s.html_safe
    if @cms_article.update_attributes(params[:cms_article])
      redirect_to cms_article_path(file_id: @cms_article.slug), notice: t("u.s")
    else
      gon.width = "300px"
      gon.height = "300px"      
      @viz_vizs = Viz::Viz.find(:all, order: "updated_at desc")
      render action: "edit"
    end
  end

  def destroy
    @cms_article.update_attributes(is_published: false,
      archieved: false, is_deleted: true)
    redirect_to all_articles_path, notice: "Record deleted."
  end

  def sort
    params[:sort].each_with_index do |id, index|      
      positionx = index+1
      Cms::Article.where(slug: id).update_all(position: positionx)
    end
    render nothing: true
  end  
  
  def nested_article
    @cms_articles = Cms::Article.where("tag IS NOT null AND tag <> '' AND is_published = true").order(:position)
    @cms_article  = Cms::Article.where(slug: "#{params[:nested_article]}").first
    @selected_article = @cms_article.slug
    @setting = Setting.first
    @template = JSON.parse(@setting.page_builder_config)
    if !Data::Filz.where(slug: "#{@selected_article}-traffic").last.nil?
      @all_years = JSON.parse(Data::Filz.where(slug: "#{@selected_article}-traffic").last.content)
      @all_years.shift
      @all_years = @all_years.collect{|k| k[5]}.uniq.sort{|k| -k}
    end
    @provider = Provider.where(name: @cms_article.title).first
    gon.width = ""
    gon.height = ""
    render action: "show"
  end
  private
  
  def find_objects
    if params[:file_id].present? 
      @cms_article = Cms::Article.find(params[:file_id])
    end    
    @viz_vizs = Viz::Viz.find(:all, order: "updated_at desc")
  end
  
  def sort_column
    Cms::Article.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  
    
end
