<?xml version="1.0" encoding="UTF-8"?>
<GestureMarkupLanguage xmlns:gml="http://gestureworks.com/gml/version/1.0">
	
	<Gesture_set gesture_set_name="basic-core-gestures">
				
					<comment>The 'basic-core-gestures' are the simple form of the classic roate scale and drag gestures commonly used to manipulate touch objects.</comment>
		
					<Gesture id="n-drag" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points between 1 and 10. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
				
				<Gesture id="n-scale" type="scale">
					
						<comment>The 'n-scale' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative separation
						of the touch points are tracked and grouped into a cluster. Changes in the separation of the cluster are mapped directly to the scale of the touch object.</comment>
						
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min=".001" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min=".001" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-rotate" type="rotate">
				<comment>The 'n-rotate' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative orientation
						of the touch points are tracked and grouped into a cluster. This change in the orientation of the cluster is mapped directly to the rotation of the touch object.</comment>
					
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="2" point_number_max="10"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="rotate"/>
						<returns>
							<property id="rotate_dtheta" result="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event type="rotate">
							<property ref="rotate_dtheta" target="rotate"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
					<Gesture id="n-scale-viewer" type="scale">
					
						<comment>The 'n-scale' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative separation
						of the touch points are tracked and grouped into a cluster. Changes in the separation of the cluster are mapped directly to the scale of the touch object.</comment>
						
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<delta_filter>
								<property ref="scale_dsx" active="true" delta_min=".001" delta_max="100"/>
								<property ref="scale_dsy" active="true" delta_min=".001" delta_max="100"/>
								<property ref="scale_dsx" active="true" delta_min="0.001" delta_max="0.025"/>
								<property ref="scale_dsy" active="true" delta_min="0.001" delta_max="0.025"/>
							</delta_filter>
							<boundary_filter>
								<property ref="scale_dsx" active="true" boundary_min="1" boundary_max="1.5"/>
								<property ref="scale_dsy" active="true" boundary_min="1" boundary_max="1.5"/>
							</boundary_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>					

		</Gesture_set>	
			
			
			
			
			
		
			
			
		<Gesture_set gesture_set_name="inertial-core-gestures">
		
				<Gesture id="n-drag-inertia" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction="0.9"/>
								<property ref="drag_dy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="5" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="5" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>

					
					
					
				<Gesture id="n-drag-album" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="false" friction="0.5"/>
								<property ref="drag_dy" active="false" friction="0.5"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="5" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="5" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>					

					
					
					
				<Gesture id="n-drag-viewer" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="false" friction="0.7"/>
								<property ref="drag_dy" active="false" friction="0.7"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="5" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="5" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>

				<Gesture id="n-tap" type="tap">
						<match>
							<action>
								<initial>
									<point event_duration_max="200" translation_max="10"/>
									<cluster point_number="0"/>
									<event touch_event="touchEnd"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="temporalmetric" type="discrete">
								<library module="tap"/>
								<returns>
									<property id="tap_x" result="x"/>
									<property id="tap_y" result="y"/>
									<property id="tap_n" result="n"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
								<gesture_event  type="tap">
									<property ref="tap_x"/>
									<property ref="tap_y"/>
									<property ref="tap_n"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>					
					
					
			</Gesture_set>		
				
	
</GestureMarkupLanguage>