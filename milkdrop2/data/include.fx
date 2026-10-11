#define M_PI 3.14159265359
#define M_PI_2 6.28318530718
#define M_INV_PI_2 0.159154943091895

float4 rand_frame;  // random float4, updated each frame
float4 rand_preset; // random float4, updated once per *preset*
float4 _c0;  // .xy = multiplier to use on UV's to paste an image fullscreen, *aspect-aware*; .zw = inverse.
float4 _c1, _c2, _c3, _c4;
float4 _c5;  // .xy = scale,bias for reading blur1; .zw = scale,bias for reading blur2;
float4 _c6;  // .xy = scale,bias for reading blur3; .zw = blur1_min,blur1_max
float4 _c7;  // .xy ~= float2(1024, 768); .zw ~= float2(1 / 1024.0, 1 / 768.0)
float4 _c8;  // .xyzw ~= 0.5 + 0.5 * cos(time * float4(~0.3, ~1.3, ~5, ~20))
float4 _c9;  // .xyzw ~= 0.5 + 0.5 * sin(time * float4(~0.3, ~1.3, ~5, ~20))
float4 _c10; // .xyzw ~= 0.5 + 0.5 * cos(time * float4(~0.005, ~0.008, ~0.013, ~0.022))
float4 _c11; // .xyzw ~= 0.5 + 0.5 * sin(time * float4(~0.005, ~0.008, ~0.013, ~0.022))
float4 _c12; // .xyz = mip info for main image (.x = #across, .y = #down, .z = avg); .w = unused
float4 _c13; // .xy = blur2_min,blur2_max; .zw = blur3_min,blur3_max
float4 _c14; // .xy = mouse position; .z = button hold; .z = mouse click
float4 _c15; // .x = hour, .y = minute, .z = second, .w = time converted to seconds
float4 _c16; // .x = year, .y = month, .z = day, .w = weekday (1-7)
float4 _c17; // .x = bass_smooth, .y = mid_smooth, .z = treb_smooth, .w = vol_smooth
float4 _c18; // .x = vis_intensity, .y = vis_shift, .z = vis_version; .w = FFT Hz reference
float4 _c19; // .x = colshift_hue, .y = colshift_saturation, .z = colshift_brightness; .w = unused
float4 _c20; // .x = gamma_adj, .y = echo_alpha, .z = echo_inv_zoom, .w = echo_orient
float4 _qa;  // q vars bank 1 [q1-q4]
float4 _qb;  // q vars bank 2 [q5-q8]
float4 _qc;  // q vars bank 3 [q9-q12]
float4 _qd;  // q vars bank 4 [q13-q16]
float4 _qe;  // q vars bank 5 [q17-q20]
float4 _qf;  // q vars bank 6 [q21-q24]
float4 _qg;  // q vars bank 7 [q25-q28]
float4 _qh;  // q vars bank 8 [q29-q32]
float4 _qi;  // q vars bank 9 [q33-q36]
float4 _qj;  // q vars bank 10 [q37-q40]
float4 _qk;  // q vars bank 11 [q41-q44]
float4 _ql;  // q vars bank 12 [q45-q48]
float4 _qm;  // q vars bank 13 [q49-q52]
float4 _qn;  // q vars bank 14 [q53-q56]
float4 _qo;  // q vars bank 15 [q57-q60]
float4 _qp;  // q vars bank 16 [q61-q64]

// Note: In general, do not use the current time with the *dynamic* rotations!
float4x3 rot_s1; // four random, static rotations randomized at preset load time
float4x3 rot_s2; // minor translation component (<1)
float4x3 rot_s3;
float4x3 rot_s4;

float4x3 rot_d1; // four random, slowly changing rotations
float4x3 rot_d2;
float4x3 rot_d3;
float4x3 rot_d4;
float4x3 rot_f1; // four random, faster changing rotations
float4x3 rot_f2;
float4x3 rot_f3;
float4x3 rot_f4;
float4x3 rot_vf1; // four random, very fast changing rotations
float4x3 rot_vf2;
float4x3 rot_vf3;
float4x3 rot_vf4;
float4x3 rot_uf1; // four random, ultra fast changing rotations
float4x3 rot_uf2;
float4x3 rot_uf3;
float4x3 rot_uf4;

float4x3 rot_rand1; // random every frame
float4x3 rot_rand2;
float4x3 rot_rand3;
float4x3 rot_rand4;

#define time _c2.x
#define fps _c2.y
#define frame _c2.z
#define progress _c2.w
#define bass _c3.x
#define mid _c3.y
#define treb _c3.z
#define vol _c3.w
#define bass_att _c4.x
#define mid_att _c4.y
#define treb_att _c4.z
#define vol_att _c4.w
#define q1 _qa.x
#define q2 _qa.y
#define q3 _qa.z
#define q4 _qa.w
#define q5 _qb.x
#define q6 _qb.y
#define q7 _qb.z
#define q8 _qb.w
#define q9 _qc.x
#define q10 _qc.y
#define q11 _qc.z
#define q12 _qc.w
#define q13 _qd.x
#define q14 _qd.y
#define q15 _qd.z
#define q16 _qd.w
#define q17 _qe.x
#define q18 _qe.y
#define q19 _qe.z
#define q20 _qe.w
#define q21 _qf.x
#define q22 _qf.y
#define q23 _qf.z
#define q24 _qf.w
#define q25 _qg.x
#define q26 _qg.y
#define q27 _qg.z
#define q28 _qg.w
#define q29 _qh.x
#define q30 _qh.y
#define q31 _qh.z
#define q32 _qh.w
#define q33 _qi.x
#define q34 _qi.y
#define q35 _qi.z
#define q36 _qi.w
#define q37 _qj.x
#define q38 _qj.y
#define q39 _qj.z
#define q40 _qj.w
#define q41 _qk.x
#define q42 _qk.y
#define q43 _qk.z
#define q44 _qk.w
#define q45 _ql.x
#define q46 _ql.y
#define q47 _ql.z
#define q48 _ql.w
#define q49 _qm.x
#define q50 _qm.y
#define q51 _qm.z
#define q52 _qm.w
#define q53 _qn.x
#define q54 _qn.y
#define q55 _qn.z
#define q56 _qn.w
#define q57 _qo.x
#define q58 _qo.y
#define q59 _qo.z
#define q60 _qo.w
#define q61 _qp.x
#define q62 _qp.y
#define q63 _qp.z
#define q64 _qp.w

#define aspect _c0
#define texsize _c7 // .xy = (w, h); .zw = (1 / (float)w, 1 / (float)h)
#define roam_cos _c8
#define roam_sin _c9
#define slow_roam_cos _c10
#define slow_roam_sin _c11
#define mip_x _c12.x
#define mip_y _c12.y
#define mip_xy _c12.xy
#define mip_avg _c12.z
#define blur1_min _c6.z
#define blur1_max _c6.w
#define blur2_min _c13.x
#define blur2_max _c13.y
#define blur3_min _c13.z
#define blur3_max _c13.w
#define mouse _c14
#define mouse_x _c14.x
#define mouse_y _c14.y
#define mouse_pos _c14.xy
#define mouse_hold _c14.z
#define mouse_click _c14.w
#define hour _c15.x
#define minute _c15.y
#define second _c15.z
#define total_seconds _c15.w
#define year _c16.x
#define month _c16.y
#define day _c16.z
#define weekday _c16.w
#define bass_smooth _c17.x
#define mid_smooth _c17.y
#define treb_smooth _c17.z
#define vol_smooth _c17.w
#define vis_intensity _c18.x
#define vis_shift _c18.y
#define vis_version _c18.z
#define fft_hz_ref _c18.w
#define colshift_hue _c19.x
#define colshift_saturation _c19.y
#define colshift_brightness _c19.z
#define gamma_adj _c20.x
#define echo_alpha_param _c20.y
#define echo_inv_zoom _c20.z
#define echo_orient_param _c20.w

#define GetMain(uv) (tex2D(sampler_main, uv).xyz)
#define GetPixel(uv) (tex2D(sampler_main, uv).xyz)
#define GetBlur1(uv) (tex2D(sampler_blur1, uv).xyz * _c5.x + _c5.y)
#define GetBlur2(uv) (tex2D(sampler_blur2, uv).xyz * _c5.z + _c5.w)
#define GetBlur3(uv) (tex2D(sampler_blur3, uv).xyz * _c6.x + _c6.y)

#define GetFFT(p) (tex2D(sampler_fft, float2(saturate((p)), 0.25)).x)
#define GetFFTPeak(p) (tex2D(sampler_fft, float2(saturate((p)), 0.75)).x)
#define GetFFTHz(hz) (GetFFT(saturate((hz) / fft_hz_ref)))
#define GetFFTPeakHz(hz) (GetFFTPeak(saturate((hz) / fft_hz_ref)))
#define GetWaveLeft(p) (tex2D(sampler_wave, float2(saturate((p)), 0.25)).x)
#define GetWaveRight(p) (tex2D(sampler_wave, float2(saturate((p)), 0.75)).x)
#define GetWave(p) ((GetWaveLeft(p) + GetWaveRight(p)) * 0.5)

#define lum(x) (dot(x, float3(0.32, 0.49, 0.29)))
float3 shiftHSV(float3 c)
{
    float3 rgb = c;
    if (colshift_hue != 0.0 || colshift_saturation != 0.0 || colshift_brightness != 0.0)
    {
        float4 K = float4(0, -1.0 / 3.0, 2.0 / 3.0, -1);
        float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
        float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
        float d = q.x - min(q.w, q.y), e = 1e-10;
        float h = frac(abs(q.z + (q.w - q.y) / (6.0 * d + e)) + colshift_hue * 0.5);
        float s = d / (q.x + e);
        float v = q.x;
        s = (colshift_saturation <= 0.0) ? s * (1.0 + colshift_saturation) : s + (1.0 - s) * colshift_saturation;
        v = (colshift_brightness <= 0.0) ? v * (1.0 + colshift_brightness) : v + (1.0 - v) * colshift_brightness;
        float3 t = abs(frac(h + float3(0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
        rgb = v * lerp(float3(1, 1, 1), saturate(t - 1.0), s);
    }
    return rgb;
}

float  _safe_normalize(float  x) { return sign(x); }
float2 _safe_normalize(float2 x) { float d = dot(x, x); return d > 0.0 ? x * rsqrt(d) : (float2)0.0; }
float3 _safe_normalize(float3 x) { float d = dot(x, x); return d > 0.0 ? x * rsqrt(d) : (float3)0.0; }
float4 _safe_normalize(float4 x) { float d = dot(x, x); return d > 0.0 ? x * rsqrt(d) : (float4)0.0; }
float  _safe_sqrt(float  x) { return sqrt(abs(x)); }
float2 _safe_sqrt(float2 x) { return sqrt(abs(x)); }
float3 _safe_sqrt(float3 x) { return sqrt(abs(x)); }
float4 _safe_sqrt(float4 x) { return sqrt(abs(x)); }
float  _safe_log(float  x) { return log(max(1e-30, x)); }
float2 _safe_log(float2 x) { return log(max(1e-30, x)); }
float3 _safe_log(float3 x) { return log(max(1e-30, x)); }
float4 _safe_log(float4 x) { return log(max(1e-30, x)); }
float  _safe_tan(float  x) { return clamp(tan(x), -1e4, 1e4); }
float2 _safe_tan(float2 x) { return clamp(tan(x), -1e4, 1e4); }
float3 _safe_tan(float3 x) { return clamp(tan(x), -1e4, 1e4); }
float4 _safe_tan(float4 x) { return clamp(tan(x), -1e4, 1e4); }
float  _safe_pow(float  x, float  y) { return pow(abs(x), y); }
float2 _safe_pow(float2 x, float2 y) { return pow(abs(x), y); }
float3 _safe_pow(float3 x, float3 y) { return pow(abs(x), y); }
float4 _safe_pow(float4 x, float4 y) { return pow(abs(x), y); }
float  _safe_asin(float  x) { return asin(clamp(x, -1.0, 1.0)); }
float2 _safe_asin(float2 x) { return asin(clamp(x, -1.0, 1.0)); }
float3 _safe_asin(float3 x) { return asin(clamp(x, -1.0, 1.0)); }
float4 _safe_asin(float4 x) { return asin(clamp(x, -1.0, 1.0)); }
float  _safe_acos(float  x) { return acos(clamp(x, -1.0, 1.0)); }
float2 _safe_acos(float2 x) { return acos(clamp(x, -1.0, 1.0)); }
float3 _safe_acos(float3 x) { return acos(clamp(x, -1.0, 1.0)); }
float4 _safe_acos(float4 x) { return acos(clamp(x, -1.0, 1.0)); }
float  _safe_atan2(float y, float x) { return atan2(y, x + 1e-20); }
float  _safe_denom(float  x) { return x == 0.0 ? 1e-30 : x; }
float2 _safe_denom(float2 x) { return float2(x.x == 0.0 ? 1e-30 : x.x, x.y == 0.0 ? 1e-30 : x.y); }
float3 _safe_denom(float3 x) { return float3(x.x == 0.0 ? 1e-30 : x.x, x.y == 0.0 ? 1e-30 : x.y, x.z == 0.0 ? 1e-30 : x.z); }
float4 _safe_denom(float4 x) { return float4(x.x == 0.0 ? 1e-30 : x.x, x.y == 0.0 ? 1e-30 : x.y, x.z == 0.0 ? 1e-30 : x.z, x.w == 0.0 ? 1e-30 : x.w); }

// Aliases to match MilkDrop3, BeatDrop, MilkWave, MDropDX12.
#define mouse_clicked _c14.z
#define mouse_released _c14.w
#define sysTime _c15
#define sysDate _c16
#define sysTimeHour _c15.x
#define sysTimeMinute _c15.y
#define sysTimeSecond _c15.z
#define sysTimeTotalSeconds _c15.w
#define sysDateYear _c16.x
#define sysDateMonth _c16.y
#define sysDateDay _c16.z
#define sysDateWeekday _c16.w
#define tex1d tex1D
#define tex2d tex2D
#define tex3d tex3D
#define texcube texCUBE
#define texCube texCUBE
#define texture1D tex1D
#define texture2D tex2D
#define texture3D tex3D
#define SAMPLER1D sampler1D
#define SAMPLER2D sampler2D
#define SAMPLER3D sampler3D
#define get_fft GetFFT
#define get_fft_peak GetFFTPeak
#define get_fft_hz GetFFTHz
#define get_fft_peak_hz GetFFTPeakHz
#define get_wave_left GetWaveLeft
#define get_wave_right GetWaveRight
#define get_wave GetWave

// Previous-frame-image samplers.
texture PrevFrameImage;
sampler2D sampler_main = sampler_state { Texture = <PrevFrameImage>; };
sampler2D sampler_fc_main = sampler_state { Texture = <PrevFrameImage>; };
sampler2D sampler_pc_main = sampler_state { Texture = <PrevFrameImage>; };
sampler2D sampler_fw_main = sampler_state { Texture = <PrevFrameImage>; };
sampler2D sampler_pw_main = sampler_state { Texture = <PrevFrameImage>; };
#define sampler_FC_main sampler_fc_main
#define sampler_PC_main sampler_pc_main
#define sampler_FW_main sampler_fw_main
#define sampler_PW_main sampler_pw_main

// Built-in noise textures.
sampler2D sampler_noise_lq;
sampler2D sampler_noise_lq_lite;
sampler2D sampler_noise_mq;
sampler2D sampler_noise_hq;
sampler3D sampler_noisevol_lq;
sampler3D sampler_noisevol_hq;
float4 texsize_noise_lq;
float4 texsize_noise_lq_lite;
float4 texsize_noise_mq;
float4 texsize_noise_hq;
float4 texsize_noisevol_lq;
float4 texsize_noisevol_hq;

// Procedural blur textures.
sampler2D sampler_blur1;
sampler2D sampler_blur2;
sampler2D sampler_blur3;

// FFT audio spectrum texture.
sampler2D sampler_fft;
#define HAS_FFT_PEAK 1

// Waveform audio texture.
sampler2D sampler_wave;
