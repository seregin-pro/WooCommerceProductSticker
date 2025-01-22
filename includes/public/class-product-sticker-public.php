<?php
defined( 'ABSPATH' ) || exit;

class ProductStickerPublic {
	
	public function __construct() {
		
		if ( get_option( 'general_status' ) ) {
			$this->init_hooks();
		}
		
		wp_enqueue_style( 'product-sticker', plugin_dir_url( __FILE__ ) . 'css/product-sticker.css', array(), SPS_VERSION, 'all' );
	}
	
	private function init_hooks() {
		add_action( 'woocommerce_product_thumbnails_columns', array( $this, 'product_sticker' ) );
		add_action( 'woocommerce_before_shop_loop_item', array( $this, 'product_sticker' ) );
		add_action( 'wp_head', array( $this, 'generate_css' ) );
	}
	
	public function product_sticker() {
		global $product;
		
		$sticker_data = array(
			'left'  => array(),
			'right' => array(),
		);
		
		// Sale
		if ( $product->is_on_sale() && get_option( 'sticker_sale_status' ) ) {
			
			if ( get_option( 'sticker_sale_label' ) == 'text' || ! ( float ) $product->get_sale_price( $this ) ) {
				$class = '';
				$text  = esc_html__( 'Sale', 'product-sticker' );
			} else {
				$class = ' sticker-percent';
				$text  = $this->getPercent( ( float ) $product->get_regular_price( $this ), ( float ) $product->get_sale_price( $this ) );
			}
			
			$sticker_data[get_option( 'sticker_sale_position' )][] = array(
				'class' 	 => 'sticker-sale sticker-' . esc_html( get_option( 'sticker_sale_type' ) . $class ),
				'text'  	 => $text,
				'sort_order' => get_option( 'sticker_sale_sort_order' )
			);
		}
		
		// New
		if ( get_option( 'sticker_new_status' ) ) {
			$date_added = ( time() - strtotime ( $product->get_date_created( $this ) ) ) / 86400;
			
			if ( ( int ) $date_added <= ( int ) get_option( 'sticker_new_day' ) ) {
				$sticker_data[get_option( 'sticker_new_position' )][] = array(
					'class' 	 => 'sticker-new sticker-' . esc_html( get_option( 'sticker_new_type' ) ),
					'text'  	 => esc_html__( 'New', 'product-sticker' ),
					'sort_order' => get_option( 'sticker_new_sort_order' )
				);
			}
		}
		
		// soldout
		if ( get_option( 'sticker_soldout_status' ) && ! $product->is_in_stock() ) {
			
			$sticker_data[get_option( 'sticker_soldout_position' )][] = array(
				'class' 	 => 'sticker-soldout sticker-' . esc_html(get_option( 'sticker_soldout_type' )),
				'text'  	 => esc_html__( 'Out of stock', 'product-sticker' ),
				'sort_order' => get_option( 'sticker_soldout_sort_order' )
			);
		}
		
		if ( get_option( 'sticker_bestseller_status' ) ) {
			$total_order = $product->get_total_sales( $this );
			
			if ( ( int ) get_option( 'sticker_bestseller_sale' ) && $total_order && $total_order >= get_option( 'sticker_bestseller_sale' ) ) {
				$sticker_data[get_option( 'sticker_bestseller_position' )][] = array(
					'class' 	 => 'sticker-bestseller sticker-' . esc_html( get_option( 'sticker_bestseller_type' ) ),
					'text'  	 => esc_html__( 'Best Seller', 'product-sticker' ),
					'sort_order' => get_option( 'sticker_bestseller_sort_order' )
				);
			}
		}
		
		// Show stickers
		if ( $sticker_data ) {
			$sort_order = array();
			
			if ( $sticker_data['left'] ) {
			
				foreach ( $sticker_data['left'] as $key => $value ) {
					$sort_order['left'][$key] = $value['sort_order'];
				}
				
				array_multisort( $sort_order['left'], SORT_ASC, $sticker_data['left'] );
				
				echo '<div class="sticker-catalog sticker-left">';
				
				foreach ( $sticker_data['left'] as $sticker ) {	
					echo '<div class="' . esc_html($sticker['class']) . '">';
					echo '<div>' . esc_html($sticker['text']) . '</div>';
					echo '</div>';
				}
				
				echo '</div>';
			}

			if ( $sticker_data['right'] ) {
			
				foreach ( $sticker_data['right'] as $key => $value ) {
					$sort_order['right'][$key] = $value['sort_order'];
				}
				
				array_multisort( $sort_order['right'], SORT_ASC, $sticker_data['right'] );
				
				echo '<div class="sticker-catalog sticker-right">';
				
				foreach ( $sticker_data['right'] as $sticker ) {
					echo '<div class="' . esc_html($sticker['class']) . '">';
					echo '<div>' . esc_html($sticker['text']) . '</div>';
					echo '</div>';
				}
				
				echo '</div>';
			}
		}
	}
	
	public function special($product) {
		$price = $product->get_regular_price( $this );
		$sale = $product->get_sale_price( $this );
	}
	
	private function getPercent($price_old, $price_new) {
		return '-' . round(($price_old - $price_new) / ($price_old / 100)) . '%';
	}
	
	function generate_css() {
		$css_folder = plugin_dir_url( __FILE__ ) . 'css/image/';
		
		echo "<style type=\"text/css\">\n";
		
		if ( get_option( 'sticker_sale_status' ) ) {
			$image = get_option( 'sticker_sale_image' ) ? get_option( 'sticker_sale_image' ) : $css_folder . get_option( 'sticker_sale_type' ) . '/sticker-sale.png';
			echo ".sticker-sale{ background: url('" . esc_url( $image ) . "'); }\n";
		}
		
		if ( get_option( 'sticker_new_status' ) ) {
			$image = get_option( 'sticker_new_image' ) ? get_option( 'sticker_new_image' ) : $css_folder . get_option( 'sticker_new_type' ) . '/sticker-new.png';
			echo ".sticker-new{ background: url('" . esc_url( $image ) . "'); }\n";
		}
		
		if ( get_option( 'sticker_soldout_status' ) ) {
			$image = get_option( 'sticker_soldout_image' ) ? get_option( 'sticker_soldout_image' ) : $css_folder . get_option( 'sticker_soldout_type' ) . '/sticker-soldout.png';
			echo ".sticker-soldout{ background: url('" . esc_url( $image ) . "'); }\n";
		}
		
		if ( get_option( 'sticker_bestseller_status' ) ) {
			$image = get_option( 'sticker_bestseller_image' ) ? get_option( 'sticker_bestseller_image' ) : $css_folder . get_option( 'sticker_bestseller_type' ) . '/sticker-bestseller.png';
			echo ".sticker-bestseller{ background: url('" . esc_url( $image ) . "'); }\n";
		}
		
		echo esc_html( get_option( 'general_css' ) );
		
		echo "\n</style>\n";
	}
}

new ProductStickerPublic();