class ItemsController < ApplicationController

	before_action :set_message

	def new
		@sale = Sale.find(params[:sale_id])
		sku = params[:sku].strip
		sku.upcase!
		item = Product.where "sku like ?", "%#{sku}%"

		if item.first.amount > 0
			@item = Item.create
			@item.update(sale: @sale, product: item.first)
		else
			redirect_to edit_sale_path(@sale), notice: 'Produto com Estoque Zerado!'
		end
	end

	def add
		@sale = Sale.find(params[:sale_id]) #set
		@item = Item.find(params[:id])

		amount = params[:amount].to_i
		unity = @item.product.price
		discount = params[:discount].to_f
		price = unity * amount
		price = price - discount

		@item.update(amount: amount, price: price, discount: discount)
		@sale.update_total

		new_amount = @item.product.amount - amount
		@item.product.update(amount:  new_amount)

		redirect_to edit_sale_path(@sale), notice: 'Item Incluído com Sucesso!'
	end

	def destroy
		@sale = Sale.find(params[:sale_id])
		id = params[:id]
		item = Item.find(id)

		if item.amount != nil
			amount = item.amount #retorna a quantidade do produto para o estoque quando remove-o da lista
			new_amount = item.product.amount + amount
			item.product.update(amount: new_amount)
		end

		Item.destroy id
		@sale.update_total
		redirect_to edit_sale_path(@sale)
	end

end
