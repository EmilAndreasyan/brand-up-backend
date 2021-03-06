class Api::V1::CitiesController < ApplicationController
    before_action :set_country

    def index
        if @country  # if parent is defined
            @cities = @country.cities
        else
            @cities = City.all
        end
        render json: @cities
    end

    def show
        @city = City.find(params[:id])
        render json: @city
    end

    def create
       # byebug
        # @city = @country.cities.build(city_params)
        # if @country.update_city(@city) != ("city name can't be blank" || "the city already exists")
        #     @city.save
        #     render json: @country
        # else
        #     render json: {error: 'Error adding city'}
        # end
        city = @country.cities.build(city_params)
        if city.save
            render json: city
        else
            render json: {error: 'Error creating a city'}
        end
    end

    def edit
        @city = @country.cities.find_by(id: params[:id])
    end
    
    def update
        city = @country.cities.find_by(id: params[:id])
        city.update(city_params)
        if city.save
        render json: @country
        else
        render json: {error: 'Error updating city'}
        end
    end
    

    def destroy
        city = City.find(params[:id])
        country = Country.find(city.country_id)
        city.destroy
        render json: country
    end
    
    private
    def set_country
        @country ||= Country.find(params[:country_id])
    end

    def city_params
        params.require(:city).permit(:country_id, :name, :image_url, :population, :description, :comment)
    end
end
