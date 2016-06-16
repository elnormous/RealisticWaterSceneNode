RealisticWaterSceneNode
=======================

Water scene node with reflections and refractions for Irrlicht

![Water demo](http://elviss.lv/files/water_demo.jpg "Water demo")

## Usage

To create the water scene node, use the following code

```
const f32 width = 512.0f;
const f32 height = 512.0f;
std::string resourcePath;
#ifdef __APPLE__
    NSString* path = [[NSBundle mainBundle]resourcePath];
    resourcePath = [path cStringUsingEncoding:NSASCIIStringEncoding];
#endif

RealisticWaterSceneNode* water = new RealisticWaterSceneNode(SceneManager, width, height, resourcePath);
SceneManager->getRootSceneNode()->addChild(water);
```