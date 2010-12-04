class JobsController < ApplicationController

  before_filter :require_administrative_privileges
  before_filter :check_for_demo_user, :only => [:new, :create, :edit, :update, :destroy]

  def check_for_demo_user
    redirect_to :back, :notice => 'The Demo Account cannot modify system settings.' if @current_user.demo?
  end

  def index
    @jobs = Snorby::Jobs.find.all
    @process = Snorby::Worker.process
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  def last_error
    @job = Snorby::Jobs.find.get(params[:id])
    render :layout => false
  end
  
  def handler
    @job = Snorby::Jobs.find.get(params[:id])
    render :layout => false
  end

  def show
    @job = Snorby::Jobs.find.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  def edit
    @job = Snorby::Jobs.find.get(params[:id])
  end

  def update
    @job = Snorby::Jobs.find.get(params[:id])

    respond_to do |format|
      if @job.update(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job = Snorby::Jobs.find.get(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
