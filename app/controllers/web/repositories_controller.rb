class Web::RepositoriesController < Web::BaseController
  def index
    repositories = Mock::Repositories.all

    @languages = repositories
      .map { |repository| repository[:language] }
      .uniq
      .sort

    @models = repositories
      .filter_map { |repository| repository[:ai_model] }
      .uniq
      .sort

    @repositories = filter_repositories(repositories)
  end

  def show
    @repository = Mock::Repositories.find(params[:id])

    raise ActiveRecord::RecordNotFound, "Repository not found" unless @repository

    @review_history = filter_review_history(@repository[:review_history])
  end

  private

  def filter_repositories(repositories)
    result = repositories

    if params[:query].present?
      query = params[:query].downcase.strip

      result = result.select do |repository|
        repository[:name].downcase.include?(query) ||
          repository[:description].downcase.include?(query)
      end
    end

    if params[:connection_status].present?
      result = result.select do |repository|
        repository[:connection_status] == params[:connection_status]
      end
    end

    if params[:language].present?
      result = result.select do |repository|
        repository[:language] == params[:language]
      end
    end

    if params[:ai_model].present?
      result = result.select do |repository|
        repository[:ai_model] == params[:ai_model]
      end
    end

    result
  end

  def filter_review_history(reviews)
    return reviews if params[:review_query].blank?

    query = params[:review_query].downcase.strip

    reviews.select do |review|
      review[:title].downcase.include?(query) ||
        review[:pull_request_number].to_s.include?(query) ||
        review[:source_branch].downcase.include?(query) ||
        review[:target_branch].downcase.include?(query) ||
        review[:author].downcase.include?(query)
    end
  end
end