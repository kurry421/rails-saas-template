# Encoding: utf-8

# Copyright (c) 2014-2015, Richard Buggy <rich@buggy.id.au>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '.currency_list' do
    it 'returns a list of currencies' do
      expect(helper.currency_list.count).to be > 0
    end

    it 'includes test currencies' do
      count = 0

      helper.currency_list.each do |currency|
        count += 1 if currency[0] == 'USD: United States Dollar' && currency[1] == 'USD'
        count += 1 if currency[0] == 'EUR: Euro' && currency[1] == 'EUR'
        count += 1 if currency[0] == 'GBP: British Pound' && currency[1] == 'GBP'
        count += 1 if currency[0] == 'AUD: Australian Dollar' && currency[1] == 'AUD'
        count += 1 if currency[0] == 'CAD: Canadian Dollar' && currency[1] == 'CAD'
        count += 1 if currency[0] == 'NZD: New Zealand Dollar' && currency[1] == 'NZD'
        count += 1 if currency[0] == 'JPY: Japanese Yen' && currency[1] == 'JPY'
      end

      # Some currencies are included multiple times!!
      expect(count).to be > 7
    end
  end

  describe '.formatted_plan_price' do
    context 'free plans and interval_count of 1' do
      let(:plan) { FactoryGirl.build(:plan, amount: 0, interval_count: 1, interval: 'month') }

      it 'is $0.00/month without free text' do
        expect(helper.formatted_plan_price(plan)).to eq '$0.00 / month'
      end

      it 'uses the free text free text' do
        expect(helper.formatted_plan_price(plan, 'FREE')).to eq 'FREE'
      end
    end

    context 'USD Plan' do
      let(:plan) { FactoryGirl.build(:plan, amount: 500, currency: 'USD', interval_count: 1, interval: 'month') }

      it 'formats the currency correctly' do
        expect(helper.formatted_plan_price(plan)).to eq '$5.00 / month'
      end
    end

    context 'FJD Plan' do
      let(:plan) { FactoryGirl.build(:plan, amount: 500, currency: 'FJD', interval_count: 1, interval: 'month') }

      it 'formats the currency correctly' do
        expect(helper.formatted_plan_price(plan)).to eq '5.00 $ / month'
      end
    end

    context 'JPY Plan' do
      let(:plan) { FactoryGirl.build(:plan, amount: 500, currency: 'JPY', interval_count: 1, interval: 'month') }

      it 'formats the currency correctly' do
        expect(helper.formatted_plan_price(plan)).to eq '¥500 / month'
      end
    end

    context 'interval_count greater than 1' do
      it 'renders to N interval' do
        plan = FactoryGirl.build(:plan, amount: 500, interval_count: 2, interval: 'month')
        expect(helper.formatted_plan_price(plan)).to eq '$5.00 / 2 month'
      end
    end
  end

  describe '.render_errors' do
    let(:user) { User.new }

    context 'no errors' do
      it 'displays nothing' do
        expect(helper.render_errors(user)).to eq ''
      end
    end

    context 'one error' do
      it 'displays one error' do
        user.errors.add :base, '>Something'
        expect(helper.render_errors(user)).to eq '<div class="alert alert-danger">&gt;Something</div>'
      end
    end

    context 'multiple errors' do
      it 'displays multiple errors' do
        user.errors.add :base, '>Something'
        user.errors.add :base, '>Else'
        expect(helper.render_errors(user)).to(
          eq '<div class="alert alert-danger">&gt;Something</div><div class="alert alert-danger">&gt;Else</div>')
      end
    end
  end
end
