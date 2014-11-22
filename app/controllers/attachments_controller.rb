class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:reference_id, :path, :email_id)
    end


  def readfile
    @email = @attachment.email
    content = File.read(Rails.application.config.enronfiles + @attachment.reference_id)
    mail = Mail.read(Rails.application.config.enronfiles + @email.reference_id)

    toArray = convertToArr(mail.to)
    fromArray = convertToArr(mail.from)
    ccArray = convertToArr(mail.cc)
    # Get all senders and recipients of email in one array
    allPeople = toArray + fromArray + ccArray
    allPeople = allPeople.compact


    score = ""

    # Get all people (nodes) referenced in the email
    relations = @email.relation

    output = ""


    output += "#{score} \n"
    output += HTMLEntities.new.encode(content)

    unless relations.nil?
      referenced_nodes = relations.recipient.split(",") << relations.node
      # Get all nodes and their associated scores
      referenced_nodes_scores =  getscore(referenced_nodes)


      allPeople.each do |person|
        score2 = find_score(person, referenced_nodes_scores)
        output = output.gsub(person, "<b><font color=\"red\")>#{person}::#{score2}</font></b>")
        output = output.gsub("\n", "<br />")
      end
    end
    output

    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += File.read(Rails.application.config.enronfiles + @email.reference_id)

  end
  helper_method :readfile

  def convertToArr(mailtofromcc)
    tArr = Array.new
    if (mailtofromcc.instance_of? String)
      tArr = mailtofromcc.split(",")
    elsif mailtofromcc.nil? || mailtofromcc.empty?
      tArr = []
    else
      mailtofromcc.each {|to| tArr << to}
    end
  end

  def find_score(node, referenced_nodes_scores)
    score = 0
    allnodes = []
    referenced_nodes_scores.each do |email, score|
      allnodes << email
    end
    match = FuzzyMatch.new(allnodes).find(node)

    if match.nil?
      score = 0
    else
      score = referenced_nodes_scores["#{match}"]
    end

    # "===========> [#{node}]" + " [#{match}:#{score}] \n"
    score.to_s

  end

  def getscore(ids)
    scores = Hash.new
    ids.each do |id|
      scores["#{Prnode.find_by_pgid(id.to_i).pgnodename}"] = Prnode.find_by_pgid(id.to_i).pgscore
    end
    scores
  end

end
