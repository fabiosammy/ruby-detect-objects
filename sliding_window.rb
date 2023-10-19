require 'rmagick'

def sliding_window(image_path, heigh_size, width_size, step_size)
  image = Magick::Image.read(image_path).first
  width, height = image.columns, image.rows

  # Initialize an array to hold the sub-images
  sub_images = []

  # Slide the window across the image
  (0..(height - heigh_size)).step(step_size) do |y|
    (0..(width - width_size)).step(step_size) do |x|
      sub_image = image.crop(x, y, heigh_size, width_size)
      sub_image.write("subimages/sub_image_#{x}_#{y}.jpg")

      sub_images << sub_image
    end
  end

  sub_images
end

sliding_window('example.jpg', 100, 200, 50)
