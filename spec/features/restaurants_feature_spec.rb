require 'rails_helper'

feature 'restaurants' do

  before do
    # visit '/restaurants'
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant, if signed' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
    end
  end

  context 'restaurants have been added' do

    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end

    context 'creating restaurants' do

      scenario 'not possible unless signed in' do
        # visit '/restaurants'
        expect(page).not_to have_link 'Add a restaurant'
      end

      scenario 'not possible unless signed in' do
        visit '/restaurants/new'
        expect(page).to have_content 'You need to sign in or sign up before continuing'
      end

      scenario 'only by logged in users' do
        visit '/users/sign_up'
        fill_in 'Email', with: 'test@now.com'
        fill_in 'Password', with: 'makers'
        fill_in 'Password confirmation', with: 'makers'
        click_button 'Sign up'
        expect(page).to have_content 'You have signed up successfully'
        expect(page).to have_link 'Add a restaurant'
      end

      context 'signed up user creates restaurants' do

        before do
          visit '/users/sign_up'
          fill_in 'Email', with: 'test@now.com'
          fill_in 'Password', with: 'makers'
          fill_in 'Password confirmation', with: 'makers'
          click_button 'Sign up'
        end

        scenario 'disallows a name that is too short' do
          # visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end

        scenario 'prompts user to fill out a form, then displays the new restaurant' do
          # visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'KCF'
          click_button 'Create Restaurant'
          expect(page).to have_content 'KCF'
          expect(current_path).to eq '/restaurants'
        end

      end
    end
  end

  context "viewing restaurants" do

    let! (:kfc) { Restaurant.create(name:'KFC') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    before do
       Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1
       visit '/users/sign_up'
       fill_in 'Email', with: 'test@now.com'
       fill_in 'Password', with: 'makers'
       fill_in 'Password confirmation', with: 'makers'
       click_button 'Sign up'
     end

    scenario 'only allow users to edit their own entries' do
      expect(page).to have_content 'KFC'
      expect(page).not_to have_link 'Edit KFC'
    end

    scenario 'allow user to edit their own entries' do
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
      expect(page).to have_link 'Edit McDonalds'
      expect(page).not_to have_link 'Edit KFC'
    end

  end

  context 'deleting restaurants' do

    before do
       Restaurant.create name: 'KFC', description: 'Deep fried goodness'
       visit '/users/sign_up'
       fill_in 'Email', with: 'test@now.com'
       fill_in 'Password', with: 'makers'
       fill_in 'Password confirmation', with: 'makers'
       click_button 'Sign up'
     end

    scenario 'does not allow random user to remove restaurants' do
      visit '/restaurants'
      expect(page).not_to have_link 'Delete KFC'
    end

    scenario 'allow user to only remove their own restaurant' do
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
      expect(page).to have_link 'Delete McDonalds'
      expect(page).not_to have_link 'Delete KFC'
    end
  end

end
