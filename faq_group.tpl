<?php echo $header; ?>
<section>
    <section class="section-breadcrumbs">
        <div class="container">
          <div class="row">
            <div class="col-12">
              <div class="breadcrumbs">
                <ul>
          <?php foreach ($breadcrumbs as $i=> $breadcrumb) { ?>
<?php if($i+1<count($breadcrumbs)) { ?>
<li>
<a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
</li>
<?php } else { ?>
<li>
<span><?php echo $breadcrumb['text']; ?></span>
</li>
<?php } ?>
<?php } ?>  
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>
			<section class="section-about-one">
				<div class="container">
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
	  <h1><?php echo $heading_title; ?></h1>
	  <p><?php echo $description; ?></p>
	  <?php if ($faq_groups) { ?>
	  <?php if ($search) { ?>
	  <div class="row">
	    <div class="col-sm-12">
		  <div class="form-inline pull-right">
	        <?php if ($search) { ?>
			<div class="form-group">
		      <input data-empty="<?php echo $text_empty; ?>" onchange="searchFaq();" onkeyup="searchFaq();" type="text" name="search_faq" value="" placeholder="<?php echo $text_search; ?>" class="form-control" />
	        </div>
			<?php } ?>
	      </div>
		</div>
	  </div>
	  <?php } ?>
	  <div id="faq" class="faq-module">
	    <?php foreach ($faq_groups as $group => $faq_group) { ?>
	    <?php if ($group_title) { ?>
	    <div class="h4style"><?php echo $faq_group['name']; ?></div>
	    <?php } ?>
	    <?php $number_ask = 1; ?>
	    <?php if ($type) { ?>
	    <div class="panel-group panel-faq" id="collapse-group<?php echo $group; ?>">
	    <?php foreach ($faq_group['faq'] as $faq) { ?>
	      <div class="panel panel-default" data-search-ask="<?php echo $faq['search_ask']; ?>" data-search-answer="<?php echo $faq['search_answer']; ?>">
		    <div class="panel-heading">
		      <div class="panel-title"><a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#collapse-group<?php echo $group; ?>" href="#answer-<?php echo $group; ?><?php echo $number_ask; ?>"><?php if ($number) { ?><span class="badge"><?php echo $number_ask; ?></span> <?php } ?> <?php echo $faq['ask']; ?></a></div>
            </div>
            <div id="answer-<?php echo $group; ?><?php echo $number_ask; ?>" class="panel-collapse collapse">
              <div class="panel-body">
			    <?php if ($faq['short_answer']) { ?>
			    <?php echo $faq['short_answer']; ?>
			    <p><a href="<?php echo $faq['href']; ?>" class="btn btn-primary"><?php echo $button_readmore; ?></a></p>
			    <?php } else { ?>
			    <?php echo $faq['answer']; ?>
			    <?php } ?>
			  </div>
            </div>
          </div>
	    <?php $number_ask++; ?>
	    <?php } ?>
	    </div>
	    <?php } else { ?>
	    <div class="panel-faq">
          <?php foreach ($faq_group['faq'] as $faq) { ?>
	      <div data-search-ask="<?php echo $faq['search_ask']; ?>" data-search-answer="<?php echo $faq['search_answer']; ?>">
            <div class="h4style"><?php if ($number) { ?><span class="badge"><?php echo $number_ask; ?></span> <?php } ?><?php echo $faq['ask']; ?></div>
            <?php if ($faq['short_answer']) { ?>
            <?php echo $faq['short_answer']; ?>
            <p><a href="<?php echo $faq['href']; ?>" class="btn btn-primary"><?php echo $button_readmore; ?></a></p>
            <?php } else { ?>
            <?php echo $faq['answer']; ?>
            <?php } ?>
	      </div>
          <?php $number_ask++; ?>
          <?php } ?>
	    </div>
        <?php } ?>
	    <?php } ?>
	  </div>
      <?php } else { ?>
      <p><?php echo $text_no_faqs; ?></p>
      <?php } ?>
	  <?php if ($form) { ?>
	  <?php if ($guest) { ?>
	  <form class="form-horizontal" id="form-faq">
	    <div class="h4style"><?php echo $heading_ask; ?></div>
		<div class="form-group required">
		  <div class="col-sm-12">
            <label class="control-label" for="input-email"><?php echo $entry_email; ?></label>
            <input type="text" name="email" value="<?php echo $email; ?>" placeholder="<?php echo $entry_email; ?>" id="input-email" class="form-control" />
          </div>
        </div>
	    <div class="form-group required">
          <div class="col-sm-12">
			<label class="control-label" for="input-ask"><?php echo $entry_ask; ?></label>
            <textarea name="ask" rows="5" placeholder="<?php echo $entry_ask; ?>" id="input-ask" class="form-control"></textarea>
          </div>
        </div>
		<?php echo $captcha; ?>
        <div class="buttons clearfix">
          <div class="pull-right">
            <button type="button" onclick="addFaq('');" id="button-faq" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-primary"><?php echo $button_submit; ?></button>
          </div>
        </div>
	  </form>
	  <?php } else { ?>
	  <p><?php echo $text_login; ?></p>
	  <?php } ?>
	  <?php } ?>
	  <?php echo $content_bottom; ?>
	</div>
    <?php echo $column_right; ?>
  </div>
				</div>
			</section>  
</section>
<?php if ($faq_groups && $microdata) { ?>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
		<?php $items = ''; ?>
		<?php foreach ($faq_groups as $group => $faq_group) { ?>
		<?php foreach ($faq_group['faq'] as $faq) { ?>
		<?php if ($faq['microdata']) { ?>
		<?php $items .= '{ "@type": "Question", "name": "' . $faq['ask'] . '", "acceptedAnswer": { "@type": "Answer", "text": "' . $faq['answer'] . '"} },'; ?>
		<?php } ?>
		<?php } ?>
		<?php } ?>
		<?php echo substr($items, 0, strlen($items) - 1); ?>
	]
}
</script>
<?php } ?>
<?php echo $footer; ?>