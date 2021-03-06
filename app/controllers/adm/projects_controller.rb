class Adm::ProjectsController < Adm::BaseController
  menu I18n.t("adm.projects.index.menu") => Rails.application.routes.url_helpers.adm_projects_path

  has_scope :by_id, :pg_search, :user_name_contains, :order_table, :by_state
  has_scope :between_created_at, using: [ :start_at, :ends_at ], allow_blank: true
  has_scope :order_table do |controller, scope, value|
    if value.present?
      scope.order_table(value)
    else
      scope.order('created_at DESC')
    end
  end

  before_filter do
    @total_projects = Project.count
  end

  [:approve, :reject, :push_to_draft].each do |name|
    define_method name do
      @project = Project.find params[:id]
      @project.send("#{name.to_s}!")
      redirect_to :back
    end
  end

  def collection
    @projects = end_of_association_chain.page(params[:page])
  end
end
