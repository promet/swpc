<?php


namespace Drupal\block_footer_left\Plugin\Block;


use Drupal\Core\Block\BlockBase;


/**
 * Provides a block with simple text, for now.
 *
 * @Block(
 *   id = "block_footer_left",
 *   admin_label = @Translation("Block Footer Left")
 * )
 */
class BlockFooterLeft extends BlockBase {


  /**
   * {@inheritdoc}
   */
  public function build() {
    return [
      '#type' => 'markup',
      '#markup' => 'Block Footer Left.",
    ];
  }


}
