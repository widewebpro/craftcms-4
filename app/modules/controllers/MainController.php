<?php
/**
 * Test Module module for Craft CMS 3.x
 *
 * The module for expanding the capabilities of export in Craft CMS.
 *
 * @link      http://176.114.0.189/
 * @copyright Copyright (c) 2020 Wideweb
 */

namespace modules\controllers;

use craft\elements\Category;
use craft\elements\Entry;
use modules\Module;

use Craft;
use craft\web\Controller;


class MainController extends Controller
{
    protected $allowAnonymous = ['get-posts-by-year','get-posts-by-tag', 'get-media-by-year'];

    public function actionGetMediaByYear()
    {
        $yearMedia = Craft::$app->getRequest()->getParam('year');
        $offsetGet = Craft::$app->getRequest()->getParam('offset') ;
        $offset = !empty($offsetGet) ? $offsetGet : 0;

        $start = (new \DateTime("first day of January {$yearMedia}"))->format(\DateTime::ATOM);
        $end = (new \DateTime("last day of December {$yearMedia}"))->format(\DateTime::ATOM);

        $medias = Entry::find()
            ->section('media')
            ->postDate(['and', ">= {$start}", "<= {$end}"])
            ->orderBy('postDate desc')
            ->offset($offset)
            ->limit(5)
            ->all();
        $new = [];
        foreach($medias as $media){
        $media->postDate = $media->postDate->format('l F j, Y');
        array_push($new, $media);
        }
        return json_encode($medias);
    }

    public function actionGetPostsByYear()
    {
        $yearPost = Craft::$app->getRequest()->getParam('year');
        $offsetGet = Craft::$app->getRequest()->getParam('offset') ;
        $offset = !empty($offsetGet) ? $offsetGet : 0;

        $start = (new \DateTime("first day of January {$yearPost}"))->format(\DateTime::ATOM);
        $end = (new \DateTime("last day of December {$yearPost}"))->format(\DateTime::ATOM);

        $posts = Entry::find()
            ->section('blogPost')
            ->postDate(['and', ">= {$start}", "<= {$end}"])
            ->orderBy('postDate desc')
            ->offset($offset)
            ->limit(5)
            ->all();

            $new = [];
            foreach($posts as $media){
            $media->postDate = $media->postDate->format('l F j, Y');
            array_push($new, $media);
            }
        return json_encode($new);
    }

    public function actionGetPostsByTag()
    {
        $offsetGet = Craft::$app->getRequest()->getParam('offset') ;
        $offset = !empty($offsetGet) ? $offsetGet : 0;

        $tagParam = Craft::$app->getRequest()->getParam('tag');
        $tag = '';
        if (!empty($tagParam)){
            $tag = Category::find()
                ->group('blogTags')
                ->slug($tagParam)
                ->one();
        }

        $posts = [];

        $posts = Entry::find()
            ->section('blogPost')
            ->orderBy('postDate desc')
            ->relatedTo(['element' => $tag])
            ->offset($offset)
            ->limit(5)
            ->all();
        $new = [];
        foreach($posts as $media){
        $media->postDate = $media->postDate->format('l F j, Y');
        array_push($new, $media);
        }
        return json_encode($new);
    }
}
