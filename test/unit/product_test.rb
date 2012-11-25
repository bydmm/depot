# encoding: utf-8
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be postive" do
    product =Product.new(:title => '某科学的魔法禁书目录',
                         :description => "科学魔法大战",
                         :image_url => "zzz.jpg")
    product.price = -1;
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    product =Product.new(:title => '某科学的魔法禁书目录',
                         :description => "科学魔法大战",
                         :price => 1,
                         :image_url => image_url )
  end
  
  test "image url" do
    ok = %w{ feed.jpg 123.png 234.gif 456.png }
      
    bad = %w{ fred.doc fred.exe 123.xml 345.sh }
      
    ok.each do |image|
      assert new_product(image).valid?, "#{image} shouldn't be invalid"
    end
    
    bad.each do|image|
      assert new_product(image).invalid?, "#{image} shouldn't be valid"
    end    
      
  end  
  
  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "yyy",
                          :price => 1,
                          :image_url => "fred.gif")
    assert !product.save
    assert_equal "has already been taken" , product.errors[:title].join('; ')
  end  
  
  test "product is not valid without a unique title - il18n" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "yyy",
                          :price => 1,
                          :image_url => "fred.gif")
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
      product.errors[:title].join('; ')
  end
  
end
