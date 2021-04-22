class GithubSyncController < ApplicationController
  def index
    @page = params[:page]
    github = Github.new
    repos = github.get_all_repos(@page)

    existing_repo_names = Product.pluck(:github_identifier)

    @link_headers = repos.shift
    @repos = repos.reject{ |repo| existing_repo_names.include?(repo.full_name) }
      .sort_by { |repo| repo.full_name.downcase }
  end

  def sync
    github_sync = GithubProjectSynchroniser.new(params[:repos])
    repos = github_sync.run

    if contains_invalid_repository? repos
      github = Github.new
      @page = params[:page]
      repositories = github.get_all_repos(@page)

      @link_headers = repositories.shift
      @repos = repositories
      @errored_repos = repos.select { |r| r.errors }
      render :index
    else
      redirect_to products_path, notice: "All products were created successfully!"
    end
  end

  def push_event_webhook
    branch = params[:ref].split('/').last
    if branch == "master"
      if verify_signature(request.body.read)
        github_identifier = params[:repository][:full_name]
        product = Product.find_by_github_identifier(github_identifier)
        product.sync_with_github if product.present?

        Rails.logger.info "#{product.title} updated!"
        head :ok
      else
        Rails.logger.warn "Signature didn't match!"
        head :bad_request
      end
    else
      head :ok
    end
  end

  private
    def contains_invalid_repository? repos
      repos.find { |r| !r.valid? }
    end

    def verify_signature(payload_body)
      secret = Rails.application.secrets.github_webhook_secret
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
      return Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
end
