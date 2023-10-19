require 'fileutils'
require 'kmeans-clusterer'
require 'rmagick'

def extract_features(image)
  # Get the color histogram of the image
  histogram = image.color_histogram

  # Initialize an array to hold the feature values
  features = []

  # For simplicity, let's only consider the Red, Green, and Blue channels
  # Create a hash to hold the total color counts for each channel
  color_counts = { red: 0, green: 0, blue: 0 }

  # Sum up the color counts for each channel
  histogram.each do |color, count|
    color_counts[:red] += color.red * count
    color_counts[:green] += color.green * count
    color_counts[:blue] += color.blue * count
  end

  # Normalize the color counts by the total number of pixels in the image
  total_pixels = image.columns * image.rows
  color_counts.each do |channel, count|
    features << count / total_pixels.to_f
  end

  features
end

def load_sub_images(directory)
  sub_images = []

  Dir.glob("#{directory}/*.jpg").each do |file_path|
    sub_image = Magick::Image.read(file_path).first

    sub_images << {
      label: file_path.split('/')[-1],
      image: sub_image
    }
  end

  sub_images
end

sub_images = load_sub_images("./subimages")

data = sub_images.map { |sub_image| extract_features(sub_image[:image]) }

num_clusters = 10

kmeans = KMeansClusterer.run(num_clusters, data, labels: sub_images.map {|sub| sub[:label]}, runs: 10)

kmeans.clusters.each_with_index do |cluster, index|
  puts "Cluster #{index}:"
  FileUtils.mkdir_p("./groups/cluster_#{index}") unless Dir.exist?("./groups/cluster_#{index}")
  cluster.points.each do |point|
    FileUtils.cp("./subimages/#{point.label}", "./groups/cluster_#{index}/")
  end
end
