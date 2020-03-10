# frozen_string_literal: true

class Api::V1::InvitesController < ApiController
  skip_before_action :doorkeeper_authorize!, only: :token
  skip_after_action :verify_authorized, only: :token
  skip_after_action :verify_policy_scoped, only: :token

  before_action :set_invite, only: %i[show retry destroy]

  def index
    invites = policy_scope(Invite)
    authorize invites

    render json: apply_fetcheable(invites).to_blueprint
  end

  def show
    render json: @invite.to_blueprint
  end

  def token
    invite = Invite.find_by!(invitation_token: params[:invitation_token])

    render json: invite.to_blueprint
  end

  def create
    authorize Invite

    render_interactor_result(
      Invites::Create.call(invite_params.to_h),
      status: :created
    )
  end

  def retry
    UserMailer.invite(@invite.id).deliver_later

    head :no_content
  end

  def destroy
    if @invite.destroy
      head :no_content
    else
      render_validation_error(@invite)
    end
  end

  private

  def set_invite
    @invite = policy_scope(Invite).find(params[:id])
    authorize(@invite)
  end

  def invite_params
    params.permit(%i[email role first_name last_name laboratory])
  end
end
