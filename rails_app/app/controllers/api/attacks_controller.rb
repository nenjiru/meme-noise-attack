class Api::AttacksController < Api::BaseController
  def queue
    Attack.create!
    success_handler({})
  end

  def kill
    Attack.create! :kill => true, :status => :already
    success_handler({})
  end

  def check
    if Attack.still_not.present?
      Attack.still_not.update_all :status => 'already'

      if Attack.where(:kill => true).first.present?
        Attack.update_all :kill => false
        success_handler({
            attack: true,
            kill: true})
      else
        success_handler({
            attack: true,
            kill: false})
      end
    else
      success_handler({
          attack: false})
    end
  end
end
