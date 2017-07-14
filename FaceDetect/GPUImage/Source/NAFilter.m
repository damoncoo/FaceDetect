//
//  NAFilter.m
//  Test1030
//
//  Created by Nathan Ou on 16/2/19.
//  Copyright © 2016年 人生菜单（北京）科技有限公司. All rights reserved.
//

#import "NAFilter.h"

NSString *const kNAFilterBeautyString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform vec2 singleStepOffset;
 uniform highp vec4 params;
 
 varying highp vec2 textureCoordinate;
 
 const highp vec3 W = vec3(0.299,0.587,0.114);
 const mat3 saturateMatrix = mat3(
                                  1.1102,-0.0598,-0.061,
                                  -0.0774,1.0826,-0.1186,
                                  -0.0228,-0.0228,1.1772);
 
 float hardlight(float color)
{
    if(color <= 0.5)
    {
        color = color * color * 2.0;
    }
    else
    {
        color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);
    }
    return color;
}
 
 void main(){
     
     vec2 blurCoordinates[24];
     
     blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -10.0);
     blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 10.0);
     blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-10.0, 0.0);
     blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(10.0, 0.0);
     
     blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(5.0, -8.0);
     blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(5.0, 8.0);
     blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, 8.0);
     blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, -8.0);
     
     blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(8.0, -5.0);
     blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(8.0, 5.0);
     blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, 5.0);
     blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, -5.0);
     
     blurCoordinates[12] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -6.0);
     blurCoordinates[13] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 6.0);
     blurCoordinates[14] = textureCoordinate.xy + singleStepOffset * vec2(6.0, 0.0);
     blurCoordinates[15] = textureCoordinate.xy + singleStepOffset * vec2(-6.0, 0.0);
     
     blurCoordinates[16] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, -4.0);
     blurCoordinates[17] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, 4.0);
     blurCoordinates[18] = textureCoordinate.xy + singleStepOffset * vec2(4.0, -4.0);
     blurCoordinates[19] = textureCoordinate.xy + singleStepOffset * vec2(4.0, 4.0);
     
     blurCoordinates[20] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, -2.0);
     blurCoordinates[21] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, 2.0);
     blurCoordinates[22] = textureCoordinate.xy + singleStepOffset * vec2(2.0, -2.0);
     blurCoordinates[23] = textureCoordinate.xy + singleStepOffset * vec2(2.0, 2.0);
     
     
     float sampleColor = texture2D(inputImageTexture, textureCoordinate).g * 22.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[0]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[1]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[2]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[3]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[4]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[5]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[6]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[7]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[8]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[9]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[10]).g;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[11]).g;
     
     sampleColor += texture2D(inputImageTexture, blurCoordinates[12]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[13]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[14]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[15]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[16]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[17]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[18]).g * 2.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[19]).g * 2.0;
     
     sampleColor += texture2D(inputImageTexture, blurCoordinates[20]).g * 3.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[21]).g * 3.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[22]).g * 3.0;
     sampleColor += texture2D(inputImageTexture, blurCoordinates[23]).g * 3.0;
     
     sampleColor = sampleColor / 62.0;
     
     vec3 centralColor = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     float highpass = centralColor.g - sampleColor + 0.5;
     
     for(int i = 0; i < 5;i++)
     {
         highpass = hardlight(highpass);
     }
     float lumance = dot(centralColor, W);
     
     float alpha = pow(lumance, params.r);
     
     vec3 smoothColor = centralColor + (centralColor-vec3(highpass))*alpha*0.1;
     
     smoothColor.r = clamp(pow(smoothColor.r, params.g),0.0,1.0);
     smoothColor.g = clamp(pow(smoothColor.g, params.g),0.0,1.0);
     smoothColor.b = clamp(pow(smoothColor.b, params.g),0.0,1.0);
     
     vec3 lvse = vec3(1.0)-(vec3(1.0)-smoothColor)*(vec3(1.0)-centralColor);
     vec3 bianliang = max(smoothColor, centralColor);
     vec3 rouguang = 2.0*centralColor*smoothColor + centralColor*centralColor - 2.0*centralColor*centralColor*smoothColor;
     
     gl_FragColor = vec4(mix(centralColor, lvse, alpha), 1.0);
     gl_FragColor.rgb = mix(gl_FragColor.rgb, bianliang, alpha);
     gl_FragColor.rgb = mix(gl_FragColor.rgb, rouguang, params.b);
     
     vec3 satcolor = gl_FragColor.rgb * saturateMatrix;
     gl_FragColor.rgb = mix(gl_FragColor.rgb, satcolor, params.a);
 }
 
);

@interface NAFilter ()

@property (nonatomic, readwrite) GPUVector4 paramsLocation;
@property (nonatomic, readwrite) CGPoint singleStepOffset;

@end

@implementation NAFilter

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kNAFilterBeautyString]))
    {
        return nil;
    }
    
    mSingleStepOffsetLocation = [filterProgram uniformIndex:@"singleStepOffset"];
    mParamsLocation = [filterProgram uniformIndex:@"params"];
    
    self.paramsLocation = (GPUVector4){0.6f, 0.8f, 0.25f, 0.25f};// 2j
//    self.paramsLocation = (GPUVector4){0.4f, 1.f, 0.2f, 0.28f}; // 5j
//    {0.6f, 0.8f, 0.25f, 0.25f} 3j
//    {0.33f, 0.63f, 0.4f, 0.35f}  5j
    self.singleStepOffset = (CGPoint){2.0/960.f,2.0/1280.f};
    
    return self;
}

- (void)setParamsLocation:(GPUVector4)paramsLocation
{
    _paramsLocation = paramsLocation;
    [self setVec4:paramsLocation forUniform:mParamsLocation program:filterProgram];
}

- (void)setSingleStepOffset:(CGPoint)singleStepOffset
{
    _singleStepOffset = singleStepOffset;
    [self setPoint:singleStepOffset forUniform:mSingleStepOffsetLocation program:filterProgram];
}

#pragma mark -
#pragma mark Accessors

@end
